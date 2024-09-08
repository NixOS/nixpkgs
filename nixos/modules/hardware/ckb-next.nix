{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.ckb-next;

in
  {
    imports = [
      (lib.mkRenamedOptionModule [ "hardware" "ckb" "enable" ] [ "hardware" "ckb-next" "enable" ])
      (lib.mkRenamedOptionModule [ "hardware" "ckb" "package" ] [ "hardware" "ckb-next" "package" ])
    ];

    options.hardware.ckb-next = {
      enable = lib.mkEnableOption "the Corsair keyboard/mouse driver";

      gid = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 100;
        description = ''
          Limit access to the ckb daemon to a particular group.
        '';
      };

      package = lib.mkPackageOption pkgs "ckb-next" { };
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.ckb-next = {
        description = "Corsair Keyboards and Mice Daemon";
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/ckb-next-daemon ${lib.optionalString (cfg.gid != null) "--gid=${builtins.toString cfg.gid}"}";
          Restart = "on-failure";
        };
      };
    };

    meta = {
      maintainers = [ ];
    };
  }
