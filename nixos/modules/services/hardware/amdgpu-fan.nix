{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.amdgpu-fan;
  pkg = pkgs.amdgpu-fan;
  amdgpuFanConfigFile = pkgs.writeText "amdgpu-fan.yml" ''
    # speed matrix
    # -[temp(*C), speed(0-100%)]
    ${cfg.speed_matrix}

    # optional list of cards
    ${cfg.cards}
  '';

in
{

  options.services.amdgpu-fan = {
    enable = mkEnableOption "Python daemon for controlling the fans on amdgpu cards";

    speed_matrix = mkOption {
      type = types.lines;
      default = ''
        - [0, 0]
        - [40, 30]
        - [60, 50]
        - [80, 100]
      '';
      example = ''
        - [0, 0]
        - [20, 20]
        - [40, 60]
        - [60, 100]
      '';
      description = ''
            Define fan speed for different temperatures using a speed matrix
      '';
    };

    cards = mkOption {
      type = types.lines;
      default = "";
      example = ''
        cards:
        - card0
      '';
      description = ''
            Define cards that can be controlled. This can be any card returned from:
            `ls /sys/class/drm | grep "^card[[:digit:]]$"`
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkg ];
    environment.etc."amdgpu-fan.yml".source = amdgpuFanConfigFile;

    systemd.services.amdgpu-fan =  {
      description = "amdgpu fan controller";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkg}/bin/amdgpu-fan";
        Restart = "always";
      };
      restartTriggers = [ amdgpuFanConfigFile ];
    };

  };
}


