{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.autorandr;

in {

  options = {

    services.autorandr = {
      enable = mkEnableOption "handling of hotplug and sleep events by autorandr";

      defaultTarget = mkOption {
        default = "default";
        type = types.str;
        description = ''
          Fallback if no monitor layout can be detected. See the docs
          (https://github.com/phillipberndt/autorandr/blob/v1.0/README.md#how-to-use)
          for further reference.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    services.udev.packages = [ pkgs.autorandr ];

    environment.systemPackages = [ pkgs.autorandr ];

    systemd.services.autorandr = {
      wantedBy = [ "sleep.target" ];
      description = "Autorandr execution hook";
      after = [ "sleep.target" ];

      serviceConfig = {
        StartLimitInterval = 5;
        StartLimitBurst = 1;
        ExecStart = "${pkgs.autorandr}/bin/autorandr --batch --change --default ${cfg.defaultTarget}";
        Type = "oneshot";
        RemainAfterExit = false;
      };
    };

  };

  meta.maintainers = with maintainers; [ gnidorah ];
}
