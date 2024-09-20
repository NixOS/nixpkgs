{ config, lib, pkgs, ... }:

let
  cfg = config.services.auto-epp;
  format = pkgs.formats.ini {};

  inherit (lib) mkOption types;
in {
  options = {
    services.auto-epp = {
      enable = lib.mkEnableOption "auto-epp for amd active pstate";

      package = lib.mkPackageOption pkgs "auto-epp" {};

      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;
          options = {
            Settings = {
              epp_state_for_AC = mkOption {
                type = types.str;
                default = "balance_performance";
                description = ''
                  energy_performance_preference when on plugged in

                  ::: {.note}
                  See available epp states by running:
                  {command}`cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences`
                  :::
                '';
              };

              epp_state_for_BAT = mkOption {
                type = types.str;
                default = "power";
                description = ''
                  `energy_performance_preference` when on battery

                  ::: {.note}
                  See available epp states by running:
                  {command}`cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences`
                  :::
                '';
              };
            };
          };
        };
        default = {};
        description = ''
          Settings for the auto-epp application.
          See upstream example: <https://github.com/jothi-prasath/auto-epp/blob/master/sample-auto-epp.conf>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    boot.kernelParams = [
      "amd_pstate=active"
    ];

    environment.etc."auto-epp.conf".source = format.generate "auto-epp.conf" cfg.settings;
    systemd.packages = [ cfg.package ];

    systemd.services.auto-epp = {
      after = [ "multi-user.target" ];
      wantedBy  = [ "multi-user.target" ];
      description = "auto-epp - Automatic EPP Changer for amd-pstate-epp";
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ lamarios ];
}
