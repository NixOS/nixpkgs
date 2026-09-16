# System-level alternatives: coreutils, libc, FHS compatibility.
#
# These options let the user replace GNU userland components (and, later,
# libc) that NixOS uses by default, without changing any existing option.
#
# Step 7 of the project: the coreutils package.
# Step 8 of the project: the libc.
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
  alternateLibcPkgs = nixpkgsSource: nixpkgsLib: import (nixpkgsSource + "/pkgs/top-level") {
    lib = nixpkgsLib;
    localSystem = {
      system = pkgs.stdenv.hostPlatform.system;
      libc = libc.family;
    };
    config = { };
    overlays = [ ];
  };

  # /nix/store/<hash>-fhs-rootfs: the FHS-compatible root view. bin/sbin hold
  # symlinks to every binary of the system packages, lib/lib64 and usr
  # counterparts point into the glibc library output. Conventional software
  # that expects a dynamic linker (ld-linux), /bin and /usr can then be
  # pointed here with activation symlinks at the real root.
  fhsRootfs = pkgs.runCommand "fhs-rootfs" {
    binEnv = pkgs.buildEnv {
      name = "fhs-bin";
      paths = config.environment.systemPackages;
      pathsToLink = [ "/bin" ];
      ignoreCollisions = true;
    };
    libSrc = "${pkgs.glibc}/lib";
    shell = pkgs.stdenv.shell;
  } ''
    mkdir -p $out/{bin,lib,usr/bin,usr/lib}
    for f in $binEnv/bin/*; do
      n="$(basename "$f")"
      ln -s "$f" "$out/bin/$n"
      ln -s "$f" "$out/usr/bin/$n"
    done
    for f in $libSrc/*; do
      n="$(basename "$f")"
      ln -s "$f" "$out/lib/$n"
      ln -s "$f" "$out/usr/lib/$n"
    done
    ln -s "$libSrc" "$out/lib64"
    ln -s "$libSrc" "$out/usr/lib64"
    ln -s "$out/bin" "$out/sbin"
    ln -s "$out/usr/bin" "$out/usr/sbin"
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
          building the whole system locally against the chosen libc family
          (sets `nixpkgs.localSystem.libc`, overriding dependency evaluation
          in exchange for a fully locally-built configuration)
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
      preserved for it (see the plan: pull what hydra has, fall back to
      glibc). Set `localBuild` to build everything locally instead.
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
      system.build.alternateLibcPkgs = alternateLibcPkgs pkgs.path lib;
    })

    (lib.mkIf (libc.family != "glibc" && libc.localBuild) {
      # User asked to build the musl/LLVM libc versions locally: this DOES
      # override dependency evaluation, and only then.
      nixpkgs.localSystem.libc = libc.family;
      system.build.libc = libc.family;
      system.build.alternateLibcPkgs = pkgs;
    })

    (lib.mkIf fhs.enable {
      system.build.fhsRootfs = fhsRootfs;

      # Point the real /bin, /sbin, /lib, /lib64, /usr/* at the generated
      # rootfs, mirroring what a conventional FHS system has at /. Only this
      # set of directories is touched; folders Nix must not manage (/home,
      # /var, /proc, /sys, /dev, ...) are left alone.
      system.activationScripts.fhsRootfs = lib.stringAfter [ "specialfs" ] ''
        for target in bin sbin lib lib64 usr/bin usr/sbin usr/lib usr/lib64; do
          ln -sfn ${fhsRootfs}/$target /$target
        done
      '';
    })
  ];}
