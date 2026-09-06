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
      # An empty regular file means systemd will bind mount /run/machine-id
      # on top, and ConditionFirstBoot will be false (the file will never
      # change, so this makes sense). See machine-id(5) "First Boot
      # Semantics". It also serves as a target to bind mount an actually
      # persistent machine-id onto. A symlink doesn't work here since
      # systemd-machine-id-commit checks /etc/machine-id itself for being a
      # mountpoint without following symlinks, so it would never commit
      # through a symlink.
      environment.etc.machine-id = lib.mkDefault {
        text = "";
        mode = "0444";
      };

      # The upstream unit has ConditionPathIsReadWrite=/etc, which is always
      # false here. Replace it with ConditionFirstBoot: with the empty
      # placeholder above first-boot is "no" and commit stays skipped, but
      # when a persistence module bind-mounts a writable file containing
      # "uninitialized" over /etc/machine-id, first-boot is "yes" once and
      # commit writes the generated ID through the bind mount.
      #
      # An empty Condition*= assignment resets *all* condition types, and
      # this attrset is serialised in key order, so the reset goes through
      # ConditionFirstBoot (sorts first) and we re-add the upstream
      # ConditionPathIsMountPoint afterwards.
      systemd.services.systemd-machine-id-commit.unitConfig = {
        ConditionFirstBoot = lib.mkDefault [
          ""
          "true"
        ];
        ConditionPathIsMountPoint = lib.mkDefault "/etc/machine-id";
      };
    })

  ];
}
