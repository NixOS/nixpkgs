# System-level alternatives: coreutils, libc, FHS compatibility.
#
# These options let the user replace GNU userland components that NixOS uses
# by default, without changing any existing option.
{
  lib,
  config,
  pkgs,
  ...
}:

let
  coreutils' = config.system.coreutils;
  libc = config.system.libc;
  fhs = config.system.fhsCompatibility;

  # The Nixpkgs package set built with an alternate libc (musl or LLVM).
  alternateLibcPkgs =
    nixpkgsSource: nixpkgsLib:
    import (nixpkgsSource + "/pkgs/top-level") {
      lib = nixpkgsLib;
      localSystem = {
        system = pkgs.stdenv.hostPlatform.system;
        libc = libc.family;
      };
      config = { };
      overlays = [ ];
    };

  # /nix/store/<hash>-fhs-rootfs: the FHS-compatible root view built on top
  # of the existing system profile pipeline (system.path, the same store
  # profile that becomes /run/current-system/sw at boot). bin, sbin and usr
  # mirror the sw profile; lib and lib64 point into the glibc library output
  # (dynamic linker). Conventional software that expects a dynamic linker in
  # /lib64, /bin and /usr can be pointed here with activation symlinks at the
  # real root.
  fhsRootfs =
    pkgs.runCommand "fhs-rootfs"
      {
        sw = config.system.path;
        libSrc = "${pkgs.glibc}/lib";
      }
      ''
        mkdir -p $out/usr $out/lib $out/usr/lib

        ln -s $sw/bin $out/bin
        ln -s $out/bin $out/sbin
        ln -s $out/bin $out/usr/bin
        ln -s $out/bin $out/usr/sbin

        # libraries: what the sw profile carries, plus the full glibc output
        ln -s $sw/lib/* $out/lib/ 2>/dev/null || true
        ln -s $libSrc/* $out/lib/ 2>/dev/null || true
        ln -s $out/lib $out/usr/lib
        ln -s $libSrc $out/lib64
        ln -s $libSrc $out/usr/lib64

        ${lib.optionalString (config.system.foreignPackages != [ ]) ''
          for p in ${lib.concatStringsSep " " (map toString config.system.foreignPackages)}; do
            [ -d "$p" ] || continue
            while IFS= read -r f; do
              rel="''${f#$p/}"
              case "$rel" in
                nix/*|proc/*|dev/*|tmp/*) continue ;;
              esac
              # only files unique to the rootfs are merged
              [ -e "$out/$rel" ] && continue
              mkdir -p "$out/$(dirname "$rel")"
              ln -s "$f" "$out/$rel"
            done < <(cd "$p" && find . -mindepth 1 \( -type f -o -type l \) )
          done
        ''}
        # /bin/sh is provided by the shell in the system packages (bashInteractive)
      '';
in
{
  _class = "nixos";

  options.system.coreutils = lib.mkOption {
    type = lib.types.nullOr lib.types.package;
    default = null;
    description = ''
      Package to use in place of GNU coreutils for the system's environment
      and for `system.build.coreutils`. When null (the default), GNU
      coreutils (`pkgs.coreutils`) is used, exactly as in a stock NixOS
      system.

      When set:
        - `system.build.coreutils` becomes the given package,
        - the package is added to the system PATH (`environment.systemPackages`).

      Examples: `pkgs.uutils-coreutils` or a custom busybox build.

      Note: NixOS modules that already embed `pkgs.coreutils` absolute paths
      keep them (they are part of their own evaluations). For a full,
      dependency-wide override, set `nixpkgs.overlays` directly, e.g.
      `nixpkgs.overlays = [ (final: prev: { coreutils = final.uutils-coreutils; }) ];`.
    '';
    example = lib.literalExpression "pkgs.uutils-coreutils";
  };

  options.system.libc = lib.mkOption {
    type = lib.types.submodule {
      options = {
        family = lib.mkOption {
          type = lib.types.enum [
            "glibc"
            "musl"
            "llvm"
          ];
          default = "glibc";
          description = ''
            C library family to use for the alternate package set exposed as
            `system.build.alternateLibcPkgs`.

            This option does NOT change how the system's own packages are
            evaluated (no dependency override): the system keeps building
            against glibc unless `localBuild` is enabled.
          '';
        };

        localBuild = lib.mkEnableOption ''
          using the locally evaluated Nixpkgs package set (the system's own
          `pkgs`) as the alternate-libc set, instead of pulling an imported
          musl/LLVM package set from the binary caches
        '';
      };
    };
    default = { };
    description = ''
      C library family selection. When `family` is set to an alternate libc
      (musl or LLVM), `system.build.alternateLibcPkgs` is a Nixpkgs package
      set built against that libc, so packages for it can be pulled from the
      binary caches (hydra) directly. If a package is not available for the
      alternate libc, the glibc build is used instead and the glibc ABI is
      preserved for it (pull what hydra has, fall back to glibc). Set
      `localBuild` to use the locally evaluated package set instead.
    '';
  };

  options.system.fhsCompatibility = lib.mkOption {
    type = lib.types.submodule {
      options.enable = lib.mkEnableOption ''
        the FHS compatibility layer: a generated rootfs at
        `system.build.fhsRootfs` mirroring /bin, /sbin, /lib, /lib64 and
        /usr with symlinks into the Nix store, plus activation symlinks at
        the real root pointing into it
      '';
    };
    default = { };
    description = ''
      Compatibility layer for conventional Linux software that expects a
      regular filesystem hierarchy (dynamic linker in /lib64, /bin and /usr
      on PATH). Folders that Nix should not manage (/home, /var, /proc,
      /sys, /dev, ...) are not touched.
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf (coreutils' != null) {
      environment.systemPackages = [ coreutils' ];

      system.build.coreutils = coreutils';
    })

    (lib.mkIf (libc.family != "glibc") {
      # No dependency override: the evaluated system stays glibc-based.
      system.build.libc = libc.family;
      system.build.alternateLibcPkgs = lib.mkDefault (alternateLibcPkgs pkgs.path lib);
    })

    (lib.mkIf (libc.family != "glibc" && libc.localBuild) {
      # Local build: the system's own (locally evaluated) package set is used
      # as the alternate-libc set. A whole-system libc swap should be done at
      # the top level with nixpkgs.localSystem.hostPlatform etc.; defining
      # nixpkgs.* options here would break nested evaluations that do not
      # declare them (e.g. containers).
      system.build.alternateLibcPkgs = pkgs;
    })

    (lib.mkIf fhs.enable {
      system.build.fhsRootfs = fhsRootfs;

      # Stock NixOS creates /bin (binsh) and /usr/bin (usrbinenv) as real
      # directories holding only /bin/sh and /usr/bin/env. In FHS mode those
      # paths are rootfs symlinks instead, and the rootfs already provides
      # sh and env from the system profile, so the stock scripts must not
      # run: they would shadow the symlinks with real directories, or try to
      # write into a read-only store path.
      system.activationScripts.binsh = lib.mkForce "";
      system.activationScripts.usrbinenv = lib.mkForce "";

      # Point the real /bin, /sbin, /lib, /lib64, /usr/* at the generated
      # rootfs, mirroring what a conventional FHS system has at /. Only this
      # set of directories is touched; folders Nix must not manage (/home,
      # /var, /proc, /sys, /dev, ...) are left alone.
      system.activationScripts.fhsRootfs = lib.stringAfter [ "specialfs" ] ''
        for target in bin sbin lib lib64 usr/bin usr/sbin usr/lib usr/lib64; do
          # never disturb an existing real directory at these paths (for
          # example a user-provided /usr); only symlinks and absent paths
          # are managed
          if [ -d /$target ] && [ ! -L /$target ]; then
            echo "fhsRootfs: /$target already exists as a real directory; leaving it alone" >&2
            continue
          fi
          ln -sfn ${fhsRootfs}/$target /$target
        done
      '';
    })
  ];
}
