{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.hardware.pulseaudio; in

{

  options = {
  
    hardware.pulseaudio.enable = mkOption {
      default = false;
      description = ''
        Whether to enable the PulseAudio sound server.
      '';
    };

  };
  

  config = mkIf cfg.enable {

    environment.systemPackages =
      [ pkgs.pulseaudio ];

    environment.etc = mkAlways (
      [ # Create pulse/client.conf even if PulseAudio is disabled so
        # that we can disable the autospawn feature in programs that
        # are built with PulseAudio support (like KDE).
        { target = "pulse/client.conf";
          source = pkgs.writeText "client.conf"
            ''
              autospawn=${if cfg.enable then "yes" else "no"}
            '';
        }
        
      ] ++ optionals cfg.enable
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

        { target = "pulse/default.pa";
          source = "${pkgs.pulseaudio}/etc/pulse/default.pa";
        }

        { target = "pulse/system.pa";
          source = "${pkgs.pulseaudio}/etc/pulse/system.pa";
        }

      ]);

    # Allow PulseAudio to get realtime priority using rtkit.
    security.rtkit.enable = true;
      
  };

}
