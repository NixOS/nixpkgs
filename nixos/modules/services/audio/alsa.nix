# ALSA sound support.
{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) alsaUtils;

  pulseaudioEnabled = config.hardware.pulseaudio.enable;

in

{
  imports = [
    (mkRenamedOptionModule [ "sound" "enableMediaKeys" ] [ "sound" "mediaKeys" "enable" ])
  ];

  ###### interface

  options = {

    sound = {

      enable = mkOption {
        type = types.bool;
        default = false;
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

      mediaKeys = {

        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable volume and capture control with keyboard media keys.

            You want to leave this disabled if you run a desktop environment
            like KDE, Gnome, Xfce, etc, as those handle such things themselves.
            You might want to enable this if you run a minimalistic desktop
            environment or work from bare linux ttys/framebuffers.

            Enabling this will turn on <option>services.actkbd</option>.
          '';
        };

        volumeStep = mkOption {
          type = types.str;
          default = "1";
          example = "1%";
          description = ''
            The value by which to increment/decrement volume on media keys.

            See amixer(1) for allowed values.
          '';
        };

      };

    };

  };


  ###### implementation

  config = mkIf config.sound.enable {

    environment.systemPackages = [ alsaUtils ];

    environment.etc = mkIf (!pulseaudioEnabled && config.sound.extraConfig != "")
      { "asound.conf".text = config.sound.extraConfig; };

    # ALSA provides a udev rule for restoring volume settings.
    services.udev.packages = [ alsaUtils ];

    boot.kernelModules = optional config.sound.enableOSSEmulation "snd_pcm_oss";

    systemd.services.alsa-store =
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

    services.actkbd = mkIf config.sound.mediaKeys.enable {
      enable = true;
      bindings = [
        # "Mute" media key
        { keys = [ 113 ]; events = [ "key" ];       command = "${alsaUtils}/bin/amixer -q set Master toggle"; }

        # "Lower Volume" media key
        { keys = [ 114 ]; events = [ "key" "rep" ]; command = "${alsaUtils}/bin/amixer -q set Master ${config.sound.mediaKeys.volumeStep}- unmute"; }

        # "Raise Volume" media key
        { keys = [ 115 ]; events = [ "key" "rep" ]; command = "${alsaUtils}/bin/amixer -q set Master ${config.sound.mediaKeys.volumeStep}+ unmute"; }

        # "Mic Mute" media key
        { keys = [ 190 ]; events = [ "key" ];       command = "${alsaUtils}/bin/amixer -q set Capture toggle"; }
      ];
    };

  };

}
