{ config, lib, pkgs, ... }:

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
      ];

      boot.initrd.availableKernelModules = [ "loop" "erofs" "overlay" ];

      boot.initrd.systemd = {
        mounts = [
          {
            where = "/run/etc-metadata";
            what = "/tmp/etc-metadata-image";
            type = "erofs";
            options = "loop";
            unitConfig = {
              # Since this unit depends on the nix store being mounted, it cannot
              # be a dependency of local-fs.target, because if it did, we'd have
              # local-fs.target ordered after the nix store mount which would cause
              # things like network.target to only become active after the nix store
              # has been mounted.
              # This breaks for instance setups where sshd needs to be up before
              # any encrypted disks can be mounted.
              DefaultDependencies = false;
              RequiresMountsFor = [
                "/sysroot/nix/store"
              ];
            };
            requires = [
              config.boot.initrd.systemd.services.find-etc-metadata-image.name
            ];
            after = [
              "local-fs-pre.target"
              config.boot.initrd.systemd.services.find-etc-metadata-image.name
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
        services = lib.mkMerge [
          (lib.mkIf config.system.etc.overlay.mutable {
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
          })
          {
            find-etc-metadata-image = {
              description = "Find the path to the etc metadata image";
              wants = [
                config.boot.initrd.systemd.services.initrd-find-nixos-closure.name
              ];
              after = [
                config.boot.initrd.systemd.services.initrd-find-nixos-closure.name
              ];
              before = [ "shutdown.target" ];
              conflicts = [ "shutdown.target" ];
              unitConfig = {
                DefaultDependencies = false;
                RequiresMountsFor = "/sysroot/nix/store";
              };
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };

              script = /* bash */ ''
                set -uo pipefail

                closure="$(realpath /nixos-closure)"

                metadata_image="$(chroot /sysroot ${lib.getExe' pkgs.coreutils "realpath"} "$closure/etc-metadata-image")"
                ln -s "/sysroot$metadata_image" /tmp/etc-metadata-image
              '';
            };
          }
        ];
      };

    })

  ];
}
