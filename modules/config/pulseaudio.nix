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

    hardware.pulseaudio.package = mkOption {
      default = pkgs.pulseaudio;
      example = "pkgs.pulseaudio.override { jackaudioSupport = true; }";
      description = ''
        The PulseAudio derivation to use.  This can be used to enable
        features (such as JACK support) that are not enabled in the
        default PulseAudio in Nixpkgs.
      '';
    };

  };


  config = mkMerge
    [ # Create pulse/client.conf even if PulseAudio is disabled so
      # that we can disable the autospawn feature in programs that
      # are built with PulseAudio support (like KDE).
      { environment.etc = singleton
          { target = "pulse/client.conf";
            source = pkgs.writeText "client.conf"
              ''
                autospawn=${if cfg.enable then "yes" else "no"}
                ${optionalString cfg.enable ''
                  daemon-binary=${cfg.package}/bin/pulseaudio
                ''}
              '';
          };
      }

      (mkIf cfg.enable {

        environment.systemPackages = [ cfg.package ];

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

            { target = "pulse/default.pa";
              source = "${cfg.package}/etc/pulse/default.pa";
            }

            { target = "pulse/system.pa";
              source = "${cfg.package}/etc/pulse/system.pa";
            }
          ];

        # Allow PulseAudio to get realtime priority using rtkit.
        security.rtkit.enable = true;

      })
    ];

}
