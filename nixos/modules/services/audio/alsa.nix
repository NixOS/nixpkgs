# ALSA sound support.
{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) alsaUtils pulseaudio;

  cfg = config.sound;
  pulseCfg = config.hardware.pulseaudio;
  pulseaudioEnabled = pulseCfg.enable;

  volumeCmds =
    let
      inherit (cfg.mediaKeys) volumeStep;
      amixer = "${alsaUtils}/bin/amixer";
      pactl = "${pulseaudio}/bin/pactl";
    in
      {
        pulseVolume =
          {
            up = "${pactl} set-sink-volume @DEFAULT_SINK@ +${volumeStep}";
            down = "${pactl} set-sink-volume @DEFAULT_SINK@ -${volumeStep}";
            mute = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
            micMute = "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
            userService = true;
          };
        alsaVolume =
          {
            up = "${amixer} -q set Master ${volumeStep}%+ unmute";
            down = "${amixer} -q set Master ${volumeStep}%- unmute";
            mute = "${amixer} -q set Master toggle";
            micMute = "${amixer} -q set Capture toggle";
            userService = false;
          };
      };

in

{

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

  config = mkIf cfg.enable {

    environment.systemPackages = [ alsaUtils ];

    environment.etc = mkIf (!pulseaudioEnabled && cfg.extraConfig != "")
      [
        {
          source = pkgs.writeText "asound.conf" cfg.extraConfig;
          target = "asound.conf";
        }
      ];

    # ALSA provides a udev rule for restoring volume settings.
    services.udev.packages = [ alsaUtils ];

    boot.kernelModules = optional cfg.enableOSSEmulation "snd_pcm_oss";

    systemd.services.alsa-store =
      {
        description = "Store Sound Card State";
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

    services.actkbd = mkIf cfg.mediaKeys.enable {
      enable = true;
      bindings =
        let
          volume =
            if pulseaudioEnabled
            then volumeCmds.pulseVolume
            else volumeCmds.alsaVolume;
        in
          [
            # "Mute" media key
            {
              userMode = volume.userService;
              keys = [ 113 ];
              events = [ "key" ];
              command = "${volume.mute}";
            }

            # "Mic Mute" media key
            {
              userMode = volume.userService;
              keys = [ 190 ];
              events = [ "key" ];
              command = "${volume.micMute}";
            }

            # "Lower Volume" media key
            {
              userMode = volume.userService;
              keys = [ 114 ];
              events = [ "key" "rep" ];
              command = "${volume.down}";
            }

            # "Raise Volume" media key
            {
              userMode = volume.userService;
              keys = [ 115 ];
              events = [ "key" "rep" ];
              command = "${volume.up}";
            }
          ];
    };
  };

}
