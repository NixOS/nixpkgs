{
  config,
  lib,
  ...
}:

let
  initrdUtilLinux = config.boot.initrd.systemd.package.util-linux;
in

{

  imports = [ ./etc.nix ];

  config = lib.mkMerge [

    {
      system.activationScripts.etc = lib.stringAfter [
        "users"
        "groups"
        "specialfs"
      ] config.system.build.etcActivationCommands;
    }

    (lib.mkIf config.system.etc.overlay.enable {

      assertions = [
        {
          assertion = config.boot.initrd.systemd.enable;
          message = "`system.etc.overlay.enable` requires `boot.initrd.systemd.enable`";
        }
        {
          assertion =
            (!config.system.etc.overlay.mutable)
            -> (config.systemd.sysusers.enable || config.services.userborn.enable);
          message = "`!system.etc.overlay.mutable` requires `systemd.sysusers.enable` or `services.userborn.enable`";
        }
        {
          assertion =
            (config.system.switch.enable)
            -> (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.6");
          message = "switchable systems with `system.etc.overlay.enable` require a newer kernel, at least version 6.6";
        }
      ];

      boot.initrd.availableKernelModules = [
        "loop"
        "erofs"
        "overlay"
      ];

      system.requiredKernelConfig = with config.lib.kernelConfig; [
        (isEnabled "EROFS_FS")
      ];

      boot.initrd.systemd = {
        storePaths = [
          "${config.system.nixos-init.package}/bin/initrd-etc-overlay"
          # Fallback for kernels without file-backed erofs, or when the
          # image lives on a filesystem that does not support it (e.g.
          # overlayfs). We cannot tell at eval time which path is taken.
          "${initrdUtilLinux}/bin/losetup"
        ];
        services.initrd-etc-overlay = {
          description = "Mount the /etc overlay";
          requiredBy = [ "initrd-fs.target" ];
          before = [
            "initrd-fs.target"
            "shutdown.target"
          ];
          conflicts = [ "shutdown.target" ];
          path = [
            config.system.nixos-init.package
            initrdUtilLinux
          ];
          unitConfig = {
            DefaultDependencies = false;
            RequiresMountsFor = "/sysroot/nix/store";
          };
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${config.system.nixos-init.package}/bin/initrd-etc-overlay";
          };
        };
      };

    })

    (lib.mkIf (config.system.etc.overlay.enable && !config.system.etc.overlay.mutable) {
      # Systemd requires /etc/machine-id exists or can be initialized on first
      # boot. This file should not be part of an image or system config because
      # it is unique to the machine, so it is initialized at first boot and
      # persisted in the system state directory, /var/lib/nixos.
      environment.etc."machine-id".source = lib.mkDefault "/var/lib/nixos/machine-id";
      boot.initrd.systemd.tmpfiles.settings.machine-id."/sysroot/var/lib/nixos/machine-id".f =
        lib.mkDefault
          {
            argument = "uninitialized";
          };
    })

  ];
}
