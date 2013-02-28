{ config, pkgs, ... }:

with pkgs.lib;
with pkgs;

let

  cfg = config.hardware.pulseaudio;

  uid = config.ids.uids.pulseaudio;
  gid = config.ids.gids.pulseaudio;

  pulseRuntimePath = "/var/run/pulse";

  # Create pulse/client.conf even if PulseAudio is disabled so
  # that we can disable the autospawn feature in programs that
  # are built with PulseAudio support (like KDE).
  clientConf = writeText "client.conf" ''
    autospawn=${if (cfg.enable && !cfg.systemWide) then "yes" else "no"}
    ${optionalString (cfg.enable && !cfg.systemWide)
      "daemon-binary=${cfg.package}/bin/pulseaudio"}
  '';

  # Write an /etc/asound.conf that causes all ALSA applications to
  # be re-routed to the PulseAudio server through ALSA's Pulse
  # plugin.
  alsaConf = writeText "asound.conf" ''
    pcm_type.pulse {
      lib ${alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so
    }
    pcm.!default {
      type pulse
      hint.description "Default Audio Device (via PulseAudio)"
    }
    ctl_type.pulse {
      lib ${alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so
    }
    ctl.!default {
      type pulse
    }
  '';

in {

  options = {

    hardware.pulseaudio = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the PulseAudio sound server.
        '';
      };

      systemWide = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If false, a PulseAudio server is launched automatically for
          each user that tries to use the sound system. The server runs
          with user priviliges. This is the recommended and most secure
          way to use PulseAudio. If true, one system-wide PulseAudio
          server is launched on boot, running as the user "pulse".
          Please read the PulseAudio documentation for more details.
        '';
      };

      configFile = mkOption {
        type = types.uniq types.path;
        default = "${pulseaudio}/etc/pulse/default.pa";
        description = ''
          The path to the configuration the PulseAudio server
          should use. By default, the "default.pa" configuration
          from the PulseAudio distribution is used.
        ''; 
      };
  
      package = mkOption {
        default = pulseaudio;
        example = "pulseaudio.override { jackaudioSupport = true; }";
        description = ''
          The PulseAudio derivation to use.  This can be used to enable
          features (such as JACK support) that are not enabled in the
          default PulseAudio in Nixpkgs.
        '';
      };
    };

  };


  config = mkMerge [
    {
      environment.etc = singleton {
        target = "pulse/client.conf";
        source = clientConf;
      };
    }

    (mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      environment.etc = singleton {
        target = "asound.conf";
        source = alsaConf;
      };

      # Allow PulseAudio to get realtime priority using rtkit.
      security.rtkit.enable = true;
    })

    (mkIf (cfg.enable && !cfg.systemWide) {
      environment.etc = singleton {
        target = "pulse/default.pa";
        source = cfg.configFile;
      };
    })

    (mkIf (cfg.enable && cfg.systemWide) {
      users.extraUsers.pulse = {
        # For some reason, PulseAudio wants UID == GID.
        uid = assert uid == gid; uid;
        group = "pulse";
        extraGroups = [ "audio" ];
        description = "PulseAudio system service user";
        home = pulseRuntimePath;
      };
  
      users.extraGroups.pulse.gid = gid;
  
      systemd.services.pulseaudio = {
        description = "PulseAudio system-wide server";
        wantedBy = [ "sound.target" ];
        before = [ "sound.target" ];
        path = [ pulseaudio ];
        environment.PULSE_RUNTIME_PATH = pulseRuntimePath;
        preStart = ''
          mkdir -p --mode 755 ${pulseRuntimePath}
          chown -R pulse:pulse ${pulseRuntimePath}
        '';
        script = ''
          exec pulseaudio --system -n --file="${cfg.configFile}"
        '';
      };
    })
  ];

}
