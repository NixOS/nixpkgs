{
  lib,
  stdenv,
  callPackage,
  runCommandLocal,
  writeShellScript,
  glibc,
  pkgsHostTarget,
  runCommandCC,
  coreutils,
  bubblewrap,
  stdenvNoCC,
}:

lib.customisation.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = [
    "targetPkgs"
    "multiPkgs"
  ];
  extendDrvArgs =
    finalAttrs:
    # NOTE:
    # `pname` and `version` will throw if they were not provided.
    # Use `name` instead of directly evaluating `pname` or `version`.
    #
    # If you need `pname` or `version` specifically, use `args` instead:
    # e.g. `args.pname or ...`.
    {
      pname ? throw "You must provide either `name` or `pname`",
      version ? throw "You must provide either `name` or `version`",
      name ? "${pname}-${version}",
      runScript ? "bash",
      nativeBuildInputs ? [ ],
      extraInstallCommands ? "",
      executableName ? args.pname or name,
      meta ? { },
      passthru ? { },
      extraPreBwrapCmds ? "",
      extraBwrapArgs ? [ ],
      unshareUser ? false,
      unshareIpc ? false,
      unsharePid ? false,
      unshareNet ? false,
      unshareUts ? false,
      unshareCgroup ? false,
      privateTmp ? false,
      chdirToPwd ? true,
      dieWithParent ? true,
      multiArch ? false, # Whether to include 32bit packages
      ...
    }@args:
    let
      # `targetPkgs` and `multiPkgs` are functions that are not present in the
      # attribute set of the derivation which is why `overrideAttrs` does not work
      # here and `override` is needed here
      buildFHSEnv = lib.makeOverridable (callPackage ./buildFHSEnv.nix { });

      fhsenv = buildFHSEnv (
        lib.attrsets.removeAttrs args [
          "runScript"
          "extraInstallCommands"
          "meta"
          "passthru"
          "extraPreBwrapCmds"
          "extraBwrapArgs"
          "dieWithParent"
          "unshareUser"
          "unshareCgroup"
          "unshareUts"
          "unshareNet"
          "unsharePid"
          "unshareIpc"
          "privateTmp"
        ]
      );

      etcBindEntries =
        let
          files = [
            # NixOS Compatibility
            "static"
            "nix" # mainly for nixVersions.git users, but also for access to nix/netrc
            # Shells
            "shells"
            "bashrc"
            "zshenv"
            "zshrc"
            "zinputrc"
            "zprofile"
            # Users, Groups, NSS
            "passwd"
            "group"
            "shadow"
            "hosts"
            "resolv.conf"
            "nsswitch.conf"
            # User profiles
            "profiles"
            # Sudo & Su
            "login.defs"
            "sudoers"
            "sudoers.d"
            # Time
            "localtime"
            "zoneinfo"
            # Other Core Stuff
            "machine-id"
            "os-release"
            # PAM
            "pam.d"
            # Fonts
            "fonts"
            # ALSA
            "alsa"
            "asound.conf"
            # SSL
            "ssl/certs"
            "ca-certificates"
            "pki"
            # Custom dconf profiles
            "dconf"
          ];
        in
        map (path: "/etc/${path}") files;

      # Here's the problem case:
      # - we need to run bash to run the init script
      # - LD_PRELOAD may be set to another dynamic library, requiring us to discover its dependencies
      # - oops! ldconfig is part of the init script, and it hasn't run yet
      # - everything explodes
      #
      # In particular, this happens with fhsenvs in fhsenvs, e.g. when running
      # a wrapped game from Steam.
      #
      # So, instead of doing that, we build a tiny static (important!) shim
      # that executes ldconfig in a completely clean environment to generate
      # the initial cache, and then execs into the "real" init, which is the
      # first time we see anything dynamically linked at all.
      #
      # Also, the real init is placed strategically at /init, so we don't
      # have to recompile this every time.
      containerInit =
        runCommandCC "container-init"
          {
            buildInputs = [ stdenv.cc.libc.static or null ];
          }
          ''
            $CXX -static -s -o $out ${./container-init.cc}
          '';

      realInit =
        run:
        writeShellScript "${name}-init" ''
          source /etc/profile
          exec ${run} "$@"
        '';

      # "use of glibc_multi is only supported on x86_64-linux"
      isMultiBuild = multiArch && stdenv.system == "x86_64-linux";

      bin = stdenvNoCC.mkDerivation {
        name = "${name}-bwrap";

        src = ./wrapper.sh;
        dontUnpack = true;
        dontConfigure = true;
        dontFixup = true;
        dontCheck = true;

        buildPhase = ''
          mkdir -p $out
          cp .attrs.sh $out/.attrs.sh
          echo "#!$builder" >> $out/wrapper.sh
          echo "source $out/.attrs.sh" >> $out/wrapper.sh
          cat $src >> $out/wrapper.sh
          chmod +x $out/wrapper.sh
        '';

        buildInputs = [
          bubblewrap
          coreutils
          glibc
        ]
        ++ lib.optionals isMultiBuild [ pkgsHostTarget.pkgsi686Linux.glibc ];

        __structuredAttrs = true;

        #pass buildInputs in a easier to access way
        inherit bubblewrap coreutils glibc;
        ia32Glibc = if isMultiBuild then pkgsHostTarget.pkgsi686Linux.glibc else "";

        # internal arguments
        inherit
          privateTmp
          extraPreBwrapCmds
          fhsenv
          etcBindEntries
          chdirToPwd
          unshareUser
          unshareIpc
          unsharePid
          unshareNet
          unshareUts
          unshareCgroup
          dieWithParent
          runScript
          isMultiBuild
          extraBwrapArgs
          containerInit
          ;
        realInit = realInit runScript;
        initArgs = ''$@'';
      };
      # we don't know which have been supplied, and want to avoid defaulting missing attrs to null.
      nameAttrs = lib.filterAttrs (
        key: value:
        builtins.elem key [
          "name"
          "pname"
          "version"
        ]
      ) args;
    in
    {
      inherit bin;

      buildPhase = ''
        mkdir -p $out/bin
        ln -s $bin/wrapper.sh $out/bin/${executableName}

        ${extraInstallCommands}
      '';

      buildLocal = true;
      dontCheck = true;
      dontUnpack = true;
      dontPatch = true;
      dontConfigure = true;

      passthru = passthru // {
        #is this actually useable?
        env =
          runCommandLocal "${name}-shell-env"
            {
              shellHook = bin.overrideAttrs { initArgs = ""; };
            }
            ''
              echo >&2 ""
              echo >&2 "*** User chroot 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
              echo >&2 ""
              exit 1
            '';
        inherit args fhsenv;
      };
      meta = {
        mainProgram = executableName;
      }
      // meta;
    }
    // nameAttrs;
}
