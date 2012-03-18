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

    boot.kernelModules = optional config.sound.enableOSSEmulation "snd_pcm_oss";

    jobs.alsa =
      { startOn = "stopped udevtrigger";

        preStart =
          ''
            mkdir -m 0755 -p $(dirname ${soundState})

            # Restore the sound state.
            ${alsaUtils}/sbin/alsactl --ignore -f ${soundState} restore
          '';

        postStop =
          ''
            # Save the sound state.
            ${alsaUtils}/sbin/alsactl --ignore -f ${soundState} store
          '';
      };

  };

}
