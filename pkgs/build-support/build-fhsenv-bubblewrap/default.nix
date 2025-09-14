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
      ...
    }@args:
    let
      buildFHSEnv = callPackage ./buildFHSEnv.nix { };

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

      bwrapCmd = import ./wrapper.nix {
        #outside dependencies
        inherit
          bubblewrap
          coreutils
          glibc
          lib
          ;

        # The splicing code does not handle `pkgsi686Linux` well, so we have to be
        # explicit about which package set it's coming from.
        inherit (pkgsHostTarget) pkgsi686Linux;

        #internal deps
        inherit
          privateTmp
          extraPreBwrapCmds
          fhsenv
          etcBindEntries
          realInit
          chdirToPwd
          unshareUser
          unshareIpc
          unsharePid
          unshareNet
          unshareUts
          unshareCgroup
          dieWithParent
          runScript
          extraBwrapArgs
          containerInit
          ;

      };
      bin = writeShellScript "${name}-bwrap" (bwrapCmd {
        initArgs = ''"$@"'';
      });
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
      buildPhase = ''
        mkdir -p $out/bin
        ln -s ${bin} $out/bin/${executableName}

        ${extraInstallCommands}
      '';

      buildLocal = true;
      dontCheck = true;
      dontUnpack = true;
      dontPatch = true;
      dontConfigure = true;

      passthru = passthru // {
        env =
          runCommandLocal "${name}-shell-env"
            {
              shellHook = bwrapCmd { };
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
