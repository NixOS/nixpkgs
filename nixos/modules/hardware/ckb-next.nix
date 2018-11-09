{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.ckb-next;

in
  {
    options.hardware.ckb-next = {
      enable = mkEnableOption "the Corsair keyboard/mouse driver";

      package = mkOption {
        type = types.package;
        default = pkgs.ckb-next;
        defaultText = "pkgs.ckb-next";
        description = ''
          The package implementing the Corsair keyboard/mouse driver.
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.ckb-next = {
        description = "Corsair Keyboards and Mice Daemon";
        wantedBy = ["multi-user.target"];
        script = "exec ${cfg.package}/bin/ckb-next-daemon";
        serviceConfig = {
          Restart = "on-failure";
          StandardOutput = "syslog";
        };
      };
    };

    meta = {
      maintainers = with lib.maintainers; [ kierdavis ];
    };
  }
