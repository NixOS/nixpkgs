# ALSA sound support.
{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) alsaUtils;

  soundState = "/var/lib/alsa/asound.state";

in

{

  ###### interface

  options = {

    sound = {

      enable = mkOption {
        default = true;
        description = ''
          Whether to enable ALSA sound.
        '';
        merge = mergeEnableOption;
      };

      enableOSSEmulation = mkOption {
        default = true;
        description = ''
          Whether to enable ALSA OSS emulation (with certain cards sound mixing may not work!).
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.sound.enable {

    environment.systemPackages = [ alsaUtils ];

    # ALSA provides a udev rule for restoring volume settings.
    services.udev.packages = [ alsaUtils ];

    boot.kernelModules = optional config.sound.enableOSSEmulation "snd_pcm_oss";

    systemd.services."alsa-store" =
      { description = "Store Sound Card State";
        wantedBy = [ "multi-user.target" ];
        unitConfig.RequiresMountsFor = "/var/lib/alsa";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
          ExecStop = "${alsaUtils}/sbin/alsactl store --ignore";
        };
      };

  };

}
