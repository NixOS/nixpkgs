{ config, lib, ... }:

{

  imports = [ ./etc.nix ];

  config = lib.mkMerge [

    {
      system.activationScripts.etc =
        lib.stringAfter [ "users" "groups" ] config.system.build.etcActivationCommands;
    }

    (lib.mkIf config.system.etc.overlay.enable {

      assertions = [
        {
          assertion = config.boot.initrd.systemd.enable;
          message = "`system.etc.overlay.enable` requires `boot.initrd.systemd.enable`";
        }
        {
          assertion = (!config.system.etc.overlay.mutable) -> (config.systemd.sysusers.enable || config.services.userborn.enable);
          message = "`!system.etc.overlay.mutable` requires `systemd.sysusers.enable` or `services.userborn.enable`";
        }
        {
          assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.6";
          message = "`system.etc.overlay.enable requires a newer kernel, at least version 6.6";
        }
        {
          assertion = config.systemd.sysusers.enable -> (config.users.mutableUsers == config.system.etc.overlay.mutable);
          message = ''
            When using systemd-sysusers and mounting `/etc` via an overlay, users
            can only be mutable when `/etc` is mutable and vice versa.
          '';
        }
      ];

      boot.initrd.availableKernelModules = [ "loop" "erofs" "overlay" ];

      boot.initrd.systemd = {
        mounts = [
          {
            where = "/run/etc-metadata";
            what = "/sysroot${config.system.build.etcMetadataImage}";
            type = "erofs";
            options = "loop";
            unitConfig.RequiresMountsFor = [
              "/sysroot/nix/store"
            ];
          }
          {
            where = "/sysroot/etc";
            what = "overlay";
            type = "overlay";
            options = lib.concatStringsSep "," ([
              "relatime"
              "redirect_dir=on"
              "metacopy=on"
              "lowerdir=/run/etc-metadata::/sysroot${config.system.build.etcBasedir}"
            ] ++ lib.optionals config.system.etc.overlay.mutable [
              "rw"
              "upperdir=/sysroot/.rw-etc/upper"
              "workdir=/sysroot/.rw-etc/work"
            ] ++ lib.optionals (!config.system.etc.overlay.mutable) [
              "ro"
            ]);
            requiredBy = [ "initrd-fs.target" ];
            before = [ "initrd-fs.target" ];
            requires = lib.mkIf config.system.etc.overlay.mutable [ "rw-etc.service" ];
            after = lib.mkIf config.system.etc.overlay.mutable [ "rw-etc.service" ];
            unitConfig.RequiresMountsFor = [
              "/sysroot/nix/store"
              "/run/etc-metadata"
            ];
          }
        ];
        services = lib.mkIf config.system.etc.overlay.mutable {
          rw-etc = {
            unitConfig = {
              DefaultDependencies = false;
              RequiresMountsFor = "/sysroot";
            };
            serviceConfig = {
              Type = "oneshot";
              ExecStart = ''
                /bin/mkdir -p -m 0755 /sysroot/.rw-etc/upper /sysroot/.rw-etc/work
              '';
            };
          };
        };
      };

    })

  ];
}
