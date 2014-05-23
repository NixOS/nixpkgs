# ALSA sound support.
{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) alsaUtils;

in

{

  ###### interface

  options = {

    sound = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable ALSA sound.
        '';
      };

      enableOSSEmulation = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable ALSA OSS emulation (with certain cards sound mixing may not work!).
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          defaults.pcm.!card 3
        '';
        description = ''
          Set addition configuration for system-wide alsa.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.sound.enable {

    environment.systemPackages = [ alsaUtils ];

    environment.etc = mkIf (config.sound.extraConfig != "")
      [
        { source = pkgs.writeText "asound.conf" config.sound.extraConfig;
          target = "asound.conf";
        }
      ];

    # ALSA provides a udev rule for restoring volume settings.
    services.udev.packages = [ alsaUtils ];

    boot.kernelModules = optional config.sound.enableOSSEmulation "snd_pcm_oss";

    systemd.services."alsa-store" =
      { description = "Store Sound Card State";
        wantedBy = [ "multi-user.target" ];
        unitConfig.RequiresMountsFor = "/var/lib/alsa";
        unitConfig.ConditionVirtualization = "!systemd-nspawn";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
          ExecStop = "${alsaUtils}/sbin/alsactl store --ignore";
        };
      };

  };

}
