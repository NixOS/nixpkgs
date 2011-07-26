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
      [ pkgs.pulseaudio ];

    environment.etc =
      [ # Write an /etc/asound.conf that causes all ALSA applications to
        # be re-routed to the PulseAudio server through ALSA's Pulse
        # plugin.
        { target = "asound.conf";
          source = pkgs.writeText "asound.conf"
            ''
              pcm_type.pulse {
                lib ${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so
              }
            
              pcm.!default {
                type pulse
                hint.description "Default Audio Device (via PulseAudio)"
              }
              
              ctl_type.pulse {
                lib ${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so
              }
            
              ctl.!default {
                type pulse
              }
            '';
        }
      ];

  };

}
