{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.ckb;

in
  {
    options.hardware.ckb = {
      enable = mkEnableOption "the Corsair keyboard/mouse driver";

      gid = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 100;
        description = ''
          Limit access to the ckb daemon to a particular group.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.ckb;
        defaultText = "pkgs.ckb";
        description = ''
          The package implementing the Corsair keyboard/mouse driver.
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.ckb = {
        description = "Corsair Keyboard Daemon";
        wantedBy = ["multi-user.target"];
        script = "${cfg.package}/bin/ckb-daemon${optionalString (cfg.gid != null) " --gid=${builtins.toString cfg.gid}"}";
        serviceConfig = {
          Restart = "always";
          StandardOutput = "syslog";
        };
      };
    };

    meta = {
      maintainers = with lib.maintainers; [ kierdavis ];
    };
  }
