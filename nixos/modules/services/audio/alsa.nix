# ALSA sound support.
{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) alsa-utils;

  cfg = config.hardware.alsa;

  pulseaudioEnabled = config.hardware.pulseaudio.enable;

in

{
  imports = [
    (mkRenamedOptionModule [ "sound" "enable" ] [ "hardware" "alsa" "enable" ])
    (mkRenamedOptionModule [ "sound" "enableOSSEmulation" ] [ "hardware" "alsa" "enableOSSEmulation" ])
    (mkRenamedOptionModule [ "sound" "extraConfig" ] [ "hardware" "alsa" "extraConfig" ])
    (mkRenamedOptionModule [ "sound" "enableMediaKeys" ] [ "hardware" "alsa" "mediaKeys" "enable" ])
    (mkRenamedOptionModule [ "sound" "mediaKeys" "enable" ] [ "hardware" "alsa" "mediaKeys" "enable" ])
    (mkRenamedOptionModule [ "sound" "mediaKeys" "volumeStep" ] [ "hardware" "alsa" "mediaKeys" "volumeStep" ])
  ];

  ###### interface

  options = {

    hardware.alsa = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable ALSA sound.
        '';
      };

      enableOSSEmulation = mkOption {
        type = types.bool;
        default = false;
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

            Enabling this will turn on {option}`services.actkbd`.
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

  config = mkIf cfg.enable {

    environment.systemPackages = [ alsa-utils ];

    environment.etc = mkIf (!pulseaudioEnabled && cfg.extraConfig != "")
      { "asound.conf".text = cfg.extraConfig; };

    # ALSA provides a udev rule for restoring volume settings.
    services.udev.packages = [ alsa-utils ];

    boot.kernelModules = optional cfg.enableOSSEmulation "snd_pcm_oss";

    systemd.services.alsa-store =
      { description = "Store Sound Card State";
        wantedBy = [ "multi-user.target" ];
        unitConfig.RequiresMountsFor = "/var/lib/alsa";
        unitConfig.ConditionVirtualization = "!systemd-nspawn";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
          ExecStart = "${alsa-utils}/sbin/alsactl restore --ignore";
          ExecStop = "${alsa-utils}/sbin/alsactl store --ignore";
        };
      };

    services.actkbd = mkIf cfg.mediaKeys.enable {
      enable = true;
      bindings = [
        # "Mute" media key
        { keys = [ 113 ]; events = [ "key" ];       command = "${alsa-utils}/bin/amixer -q set Master toggle"; }

        # "Lower Volume" media key
        { keys = [ 114 ]; events = [ "key" "rep" ]; command = "${alsa-utils}/bin/amixer -q set Master ${cfg.mediaKeys.volumeStep}- unmute"; }

        # "Raise Volume" media key
        { keys = [ 115 ]; events = [ "key" "rep" ]; command = "${alsa-utils}/bin/amixer -q set Master ${cfg.mediaKeys.volumeStep}+ unmute"; }

        # "Mic Mute" media key
        { keys = [ 190 ]; events = [ "key" ];       command = "${alsa-utils}/bin/amixer -q set Capture toggle"; }
      ];
    };

  };

}
