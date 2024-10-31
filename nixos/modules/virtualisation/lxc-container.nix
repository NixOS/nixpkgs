{ lib, config, pkgs, ... }:

{
  meta = {
    maintainers = lib.teams.lxc.members;
  };

  imports = [
    ./lxc-instance-common.nix

    (lib.mkRemovedOptionModule [ "virtualisation" "lxc" "nestedContainer" ] "")
    (lib.mkRemovedOptionModule [ "virtualisation" "lxc" "privilegedContainer" ] "")
  ];

  options = { };

  config = let
    initScript = if config.boot.initrd.systemd.enable then "prepare-root" else "init";
  in {
    boot.isContainer = true;
    boot.postBootCommands =
      ''
        # After booting, register the contents of the Nix store in the Nix
        # database.
        if [ -f /nix-path-registration ]; then
          ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration &&
          rm /nix-path-registration
        fi

        # nixos-rebuild also requires a "system" profile
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

    system.build.tarball = pkgs.callPackage ../../lib/make-system-tarball.nix {
      extraArgs = "--owner=0";

      storeContents = [
        {
          object = config.system.build.toplevel;
          symlink = "none";
        }
      ];

      contents = [
        {
          source = config.system.build.toplevel + "/${initScript}";
          target = "/sbin/init";
        }
        # Technically this is not required for lxc, but having also make this configuration work with systemd-nspawn.
        # Nixos will setup the same symlink after start.
        {
          source = config.system.build.toplevel + "/etc/os-release";
          target = "/etc/os-release";
        }
      ];

      extraCommands = "mkdir -p proc sys dev";
    };

    system.build.squashfs = pkgs.callPackage ../../lib/make-squashfs.nix {
      fileName = "nixos-lxc-image-${pkgs.stdenv.hostPlatform.system}";

      hydraBuildProduct = true;
      noStrip = true; # keep directory structure
      comp = "zstd -Xcompression-level 6";

      storeContents = [config.system.build.toplevel];

      pseudoFiles = [
        "/sbin d 0755 0 0"
        "/sbin/init s 0555 0 0 ${config.system.build.toplevel}/${initScript}"
        "/dev d 0755 0 0"
        "/proc d 0555 0 0"
        "/sys d 0555 0 0"
      ];
    };

    system.build.installBootLoader = pkgs.writeScript "install-lxc-sbin-init.sh" ''
      #!${pkgs.runtimeShell}
      ${pkgs.coreutils}/bin/ln -fs "$1/${initScript}" /sbin/init
    '';

    # networkd depends on this, but systemd module disables this for containers
    systemd.additionalUpstreamSystemUnits = ["systemd-udev-trigger.service"];

    systemd.packages = [ pkgs.distrobuilder.generator ];

    system.activationScripts.installInitScript = lib.mkForce ''
      ln -fs $systemConfig/${initScript} /sbin/init
    '';
  };
}
