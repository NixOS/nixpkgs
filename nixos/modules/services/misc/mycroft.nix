{ config, lib, pkgs, ... }:

let
  cfg = config.services.mycroft;
  uid = 9000;

in {
  meta.maintainers = with lib.maintainers; [ peterhoeg ];

  options.services.mycroft = {
    enable = lib.mkEnableOption "Mycroft AI";

    applianceMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Run mycroft as a system-wide service. You probably only want to do this on purpose-built hardware like a Raspberry Pi or similar.
      '';
    };

    voice = lib.mkOption {
      type = lib.enum [ "ap" "slt" "kal" "awb" "kal16" "rms" "awb_time" ];
      default = "ap";
      description = ''
        The voice used by Mycroft.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.systemWide = lib.mkIf cfg.applianceMode true;

    systemd = {
      packages = with pkgs; [ mycroft ];
      targets.mycroft.wantedBy = lib.mkIf cfg.applianceMode [ "multi-user.target" ];
    };
  };
}
