{ config, pkgs, ... }:

with pkgs.lib;

{

  options = {
  
    hardware.pulseaudio.enable = mkOption {
      default = false;
      description = ''
        Whether to enable the PulseAudio sound server.
      '';
    };

  };
  

  config = mkIf config.hardware.pulseaudio.enable {

    environment.systemPackages =
      [ pkgs.pulseaudio pkgs.alsaPlugins ];

    environment.etc =
      [ # Write an /etc/asound.conf that causes all ALSA applications to
        # be re-routed to the PulseAudio server through ALSA's Pulse
        # plugin.
        { target = "asound.conf";
          source = pkgs.writeText "asound.conf"
            ''
              pcm.!default {
                type pulse
                hint.description "Default Audio Device (via PulseAudio)"
              }
              ctl.!default {
                type pulse
              }
            '';
        }
      ];

    # Ensure that the ALSA Pulse plugin appears in ALSA's search path.
    environment.pathsToLink = [ "lib/alsa-lib" ];

  };

}
