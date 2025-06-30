{ lib, config, ... }:
let
  cfg = config.security.restrict-suid-sgid;
in
{
  meta.maintainers = with lib.maintainers; [ grimmauld ];

  options.security.restrict-suid-sgid = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        When enabled, it will be disallowed by default for
        services to create SUID/SGID files. Some services
        might need an explicit exception to work correctly.
      '';
    };

    allowedServices = lib.mkOption {
      type = lib.types.listOf lib.types.nonEmptyStr;
      default = [
        "suid-sgid-wrappers"
        "systemd-tmpfiles-setup"
        "systemd-tmpfiles-resetup"
      ];
      description = ''
        List of services to be allowed to create SUID/SGID files.
        On a normal nixos system, `suid-sgid-wrappers` is required
        to create suid files for e.g. sudo and fuse to work correctly,
        while `systemd-tmpfiles-setup` and `systemd-tmpfiles-resetup`
        is being used by systemd internally to fix file permissions.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # needs to be a drop-in to take effect on *all* systemd units, not just those created by nix
    # Better would be to set `RestrictSUIDSGID` in system.conf, but this is not yet supported.
    # See also: https://github.com/systemd/systemd/issues/37602
    systemd.units =
      {
        "service.d/10-restrict-suid-sgid.conf".text = ''
          [Service]
          RestrictSUIDSGID=yes
        '';
      }
      // (lib.listToAttrs (
        map (
          n:
          lib.nameValuePair "${n}.service.d/20-unrestrict-suid-sgid.conf" {
            text = ''
              [Service]
              RestrictSUIDSGID=no
            '';
          }
        ) cfg.allowedServices
      ));
  };
}
