{
  config,
  lib,
  ...
}:

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
        storePaths = lib.mkIf config.system.etc.overlay.mutable [
          "${config.system.nixos-init.package}/bin/clear-etc-opaque"
        ];
        mounts = [
          {
            where = "/run/nixos-etc-metadata";
            what = "/etc-metadata-image";
            type = "erofs";
            options = "loop,ro,nodev,nosuid";
            unitConfig = {
              RequiresMountsFor = [
                "/sysroot/nix/store"
              ];
              # find-etc only creates this symlink for a NixOS init. For a
              # non-NixOS init= (e.g. init=/bin/sh) it is absent, so skip the
              # mount instead of failing the whole initrd.
              ConditionPathExists = "/etc-metadata-image";
            };
            requires = [
              config.boot.initrd.systemd.services.initrd-find-etc.name
            ];
            after = [
              config.boot.initrd.systemd.services.initrd-find-etc.name
            ];
            requiredBy = [ "initrd-fs.target" ];
            before = [ "initrd-fs.target" ];
          }
          {
            where = "/sysroot/etc";
            what = "overlay";
            type = "overlay";
            options = lib.concatStringsSep "," (
              [
                "nodev"
                "nosuid"
                "relatime"
                "redirect_dir=on"
                "metacopy=on"
                "lowerdir=/run/nixos-etc-metadata::/etc-basedir"
              ]
              ++ lib.optionals config.system.etc.overlay.mutable [
                "rw"
                "upperdir=/sysroot/.rw-etc/upper"
                "workdir=/sysroot/.rw-etc/work"
              ]
              ++ lib.optionals (!config.system.etc.overlay.mutable) [
                "ro"
              ]
            );
            requiredBy = [ "initrd-fs.target" ];
            before = [ "initrd-fs.target" ];
            requires = [
              config.boot.initrd.systemd.services.initrd-find-etc.name
            ]
            ++ lib.optionals config.system.etc.overlay.mutable [
              config.boot.initrd.systemd.services."rw-etc".name
            ];
            after = [
              config.boot.initrd.systemd.services.initrd-find-etc.name
            ]
            ++ lib.optionals config.system.etc.overlay.mutable [
              config.boot.initrd.systemd.services."rw-etc".name
            ];
            unitConfig = {
              RequiresMountsFor = [
                "/sysroot/nix/store"
                "/run/nixos-etc-metadata"
              ];
              DefaultDependencies = false;
              # Skip for a non-NixOS init=, see the metadata mount above.
              ConditionPathExists = "/etc-basedir";
            };
          }
        ];
        services = lib.mkMerge [
          (lib.mkIf config.system.etc.overlay.mutable {
            rw-etc = {
              requiredBy = [ "initrd-fs.target" ];
              before = [ "initrd-fs.target" ];
              unitConfig = {
                DefaultDependencies = false;
                RequiresMountsFor = [
                  "/sysroot"
                  # Needed so we can clear stale opaque markers from the
                  # upperdir based on the contents of the new metadata layer
                  # before the overlay is mounted.
                  "/run/nixos-etc-metadata"
                ];
                # Skip for a non-NixOS init=, see the metadata mount above.
                ConditionPathExists = "/etc-metadata-image";
              };
              serviceConfig = {
                Type = "oneshot";
                ExecStart = [
                  "/bin/mkdir -p -m 0755 /sysroot/.rw-etc/upper /sysroot/.rw-etc/work"
                  "${config.system.nixos-init.package}/bin/clear-etc-opaque /run/nixos-etc-metadata /sysroot/.rw-etc/upper"
                ];
              };
            };
          })
          {
            initrd-find-etc = {
              description = "Find the path to the etc metadata image and based dir";
              before = [ "shutdown.target" ];
              conflicts = [ "shutdown.target" ];
              requiredBy = [ "initrd.target" ];
              path = [ config.system.nixos-init.package ];
              unitConfig = {
                DefaultDependencies = false;
                RequiresMountsFor = "/sysroot/nix/store";
              };
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = "${config.system.nixos-init.package}/bin/find-etc";
              };
            };
          }
        ];
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
