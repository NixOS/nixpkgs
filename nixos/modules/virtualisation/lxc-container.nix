{ lib, config, pkgs, ... }:

let
  cfg = config.virtualisation.lxc;
in {
  imports = [
    ./lxc-instance-common.nix
  ];

  options = {
    virtualisation.lxc = {
      nestedContainer = lib.mkEnableOption (lib.mdDoc ''
        Whether this container is configured as a nested container. On LXD containers this is recommended
        for all containers and is enabled with `security.nesting = true`.
      '');

      privilegedContainer = lib.mkEnableOption (lib.mdDoc ''
        Whether this LXC container will be running as a privileged container or not. If set to `true` then
        additional configuration will be applied to the `systemd` instance running within the container as
        recommended by [distrobuilder](https://linuxcontainers.org/distrobuilder/introduction/).
      '');
    };
  };

  config = {
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

    # TODO: build rootfs as squashfs for faster unpack
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
          source = config.system.build.toplevel + "/init";
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

    system.build.installBootLoader = pkgs.writeScript "install-lxd-sbin-init.sh" ''
      #!${pkgs.runtimeShell}
      ln -fs "$1/init" /sbin/init
    '';

    systemd.additionalUpstreamSystemUnits = lib.mkIf cfg.nestedContainer ["systemd-udev-trigger.service"];

    # Add the overrides from lxd distrobuilder
    # https://github.com/lxc/distrobuilder/blob/05978d0d5a72718154f1525c7d043e090ba7c3e0/distrobuilder/main.go#L630
    systemd.packages = [
      (pkgs.writeTextFile {
        name = "systemd-lxc-service-overrides";
        destination = "/etc/systemd/system/service.d/zzz-lxc-service.conf";
        text = ''
          [Service]
          ProcSubset=all
          ProtectProc=default
          ProtectControlGroups=no
          ProtectKernelTunables=no
          NoNewPrivileges=no
          LoadCredential=
        '' + lib.optionalString cfg.privilegedContainer ''
          # Additional settings for privileged containers
          ProtectHome=no
          ProtectSystem=no
          PrivateDevices=no
          PrivateTmp=no
          ProtectKernelLogs=no
          ProtectKernelModules=no
          ReadWritePaths=
        '';
      })
    ];

    system.activationScripts.installInitScript = lib.mkForce ''
      ln -fs $systemConfig/init /sbin/init
    '';
  };
}
