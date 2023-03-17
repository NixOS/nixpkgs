{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.ckb-next;

in
  {
    imports = [
      (mkRenamedOptionModule [ "hardware" "ckb" "enable" ] [ "hardware" "ckb-next" "enable" ])
      (mkRenamedOptionModule [ "hardware" "ckb" "package" ] [ "hardware" "ckb-next" "package" ])
    ];

    options.hardware.ckb-next = {
      enable = mkEnableOption (lib.mdDoc "the Corsair keyboard/mouse driver");

      gid = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 100;
        description = lib.mdDoc ''
          Limit access to the ckb daemon to a particular group.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.ckb-next;
        defaultText = literalExpression "pkgs.ckb-next";
        description = lib.mdDoc ''
          The package implementing the Corsair keyboard/mouse driver.
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.ckb-next = {
        description = "Corsair Keyboards and Mice Daemon";
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/ckb-next-daemon ${optionalString (cfg.gid != null) "--gid=${builtins.toString cfg.gid}"}";
          Restart = "on-failure";
        };
      };
    };

    meta = {
      maintainers = with lib.maintainers; [ ];
    };
  }
