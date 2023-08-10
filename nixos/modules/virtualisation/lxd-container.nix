{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./lxd-instance-common.nix
  ];

  options = {
    virtualisation.lxd = {
      privilegedContainer = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether this LXD container will be running as a privileged container or not. If set to `true` then
          additional configuration will be applied to the `systemd` instance running within the container as
          recommended by [distrobuilder](https://linuxcontainers.org/distrobuilder/introduction/).
        '';
      };
    };
  };

  config = {
    boot.isContainer = true;

    boot.postBootCommands = ''
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
        {
          source = config.system.build.toplevel + "/etc/os-release";
          target = "/etc/os-release";
        }
      ];

      extraCommands = "mkdir -p proc sys dev";
    };

    system.activationScripts.installInitScript = lib.mkForce ''
      ln -fs $systemConfig/init /sbin/init
    '';

    # Add the overrides from lxd distrobuilder
    # https://github.com/lxc/distrobuilder/blob/f77300bf7d7d5707b08eaf8a434d647d1ba81b5d/distrobuilder/main.go#L687-L714
    systemd.packages = let
      systemdOverride =
        pkgs.writeText "lxd-systemd-override" ''
          [Service]
          ProcSubset=all
          ProtectProc=default
          ProtectControlGroups=no
          ProtectKernelTunables=no
          NoNewPrivileges=no
          LoadCredential=
          PrivateNetwork=no
        ''
        + lib.optionalString config.virtualisation.lxd.privilegedContainer ''
          # Additional settings for privileged containers
          ProtectHome=no
          ProtectSystem=no
          PrivateDevices=no
          PrivateTmp=no
          ProtectKernelLogs=no
          ProtectKernelModules=no
          ReadWritePaths=
          ImportCredential=
        '';
    in [
      (pkgs.runCommandNoCC "toplevel-overrides.conf" {
          preferLocalBuild = true;
          allowSubstitutes = false;
        } ''
          mkdir -p $out/etc/systemd/system/service.d/
          cp ${systemdOverride} $out/etc/systemd/system/service.d/lxc.conf
        '')
    ];

    # https://github.com/lxc/distrobuilder/blob/f77300bf7d7d5707b08eaf8a434d647d1ba81b5d/distrobuilder/main.go#L797-L798
    systemd.services.systemd-networkd.serviceConfig.BindReadOnlyPaths = ["/proc" "/sys"];
    systemd.services.systemd-resolved.serviceConfig.BindReadOnlyPaths = ["/proc" "/sys"];
  };
}
