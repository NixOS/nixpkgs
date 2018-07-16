{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.powerManagement.undervolt;
in {
  options = {
    powerManagement = {
      undervolt = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable the undervolt daemon.
          '';
        };

        core = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Core offset (mV)
          '';
        };

        cache = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Cache offset (mV)
          '';
        };

        analogio = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Analogio offset (mV)
          '';
        };

        uncore = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Uncore offset (mV)
          '';
        };

        gpu = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Gpu offset (mV)
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        undervolt
      ];
    };

    systemd = {
      services = {
        undervolt = {
          after = [
            "suspend.target"
            "hibernate.target"
            "hybrid-sleep.target"
          ];
          description = "Intel undervolting";
          enable = true;
          serviceConfig = {
            ExecStart = ''
              ${pkgs.undervolt}/bin/undervolt --core ${toString cfg.core} --cache ${toString cfg.cache} --analogio ${toString cfg.analogio} --uncore ${toString cfg.uncore} --gpu ${toString cfg.gpu}
            '';
          };
          wantedBy = [
            "suspend.target"
            "hibernate.target"
            "hybrid-sleep.target"
            "multi-user.target"
          ];
        };
      };
    };
  };
}
