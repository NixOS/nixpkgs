{ config, lib, pkgs, pkgs_i686, ... }:

with pkgs;
with lib;

let

  cfg = config.hardware.pulseaudio;

  systemWide = cfg.enable && cfg.systemWide;
  nonSystemWide = cfg.enable && !cfg.systemWide;

  # Forces 32bit pulseaudio and alsaPlugins to be built/supported for apps
  # using 32bit alsa on 64bit linux.
  enable32BitAlsaPlugins = stdenv.isx86_64 && (pkgs_i686.alsaLib != null && pkgs_i686.pulseaudio != null);

  ids = config.ids;

  uid = ids.uids.pulseaudio;
  gid = ids.gids.pulseaudio;

  stateDir = "/var/run/pulse";

  # Create pulse/client.conf even if PulseAudio is disabled so
  # that we can disable the autospawn feature in programs that
  # are built with PulseAudio support (like KDE).
  clientConf = writeText "client.conf" ''
    autospawn=${if nonSystemWide then "yes" else "no"}
    ${optionalString nonSystemWide "daemon-binary=${cfg.package}/bin/pulseaudio"}
  '';

  # Write an /etc/asound.conf that causes all ALSA applications to
  # be re-routed to the PulseAudio server through ALSA's Pulse
  # plugin.
  alsaConf = writeText "asound.conf" (''
    pcm_type.pulse {
      libs.native = ${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so ;
      ${lib.optionalString enable32BitAlsaPlugins
     "libs.32Bit = ${pkgs_i686.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so ;"}
    }
    pcm.!default {
      type pulse
      hint.description "Default Audio Device (via PulseAudio)"
    }
    ctl_type.pulse {
      libs.native = ${alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so ;
      ${lib.optionalString enable32BitAlsaPlugins
     "libs.32Bit = ${pkgs_i686.alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so ;"}
    }
    ctl.!default {
      type pulse
    }
  '');

in {

  options = {

    hardware.pulseaudio = {
      enable = mkOption {
        type = types.bool;
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
          with user privileges. This is the recommended and most secure
          way to use PulseAudio. If true, one system-wide PulseAudio
          server is launched on boot, running as the user "pulse".
          Please read the PulseAudio documentation for more details.
        '';
      };

      configFile = mkOption {
        type = types.path;
        description = ''
          The path to the configuration the PulseAudio server
          should use. By default, the "default.pa" configuration
          from the PulseAudio distribution is used.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pulseaudioFull;
        example = literalExample "pkgs.pulseaudioFull";
        description = ''
          The PulseAudio derivation to use.  This can be used to disable
          features (such as JACK support, Bluetooth) that are enabled in the
          pulseaudioFull package in Nixpkgs.
        '';
      };

      daemon = {
        logLevel = mkOption {
          type = types.str;
          default = "notice";
          description = ''
            The log level that the system-wide pulseaudio daemon should use,
            if activated.
          '';
        };
      };
    };

  };


  config = mkMerge [
    {
      environment.etc = singleton {
        target = "pulse/client.conf";
        source = clientConf;
      };

      hardware.pulseaudio.configFile = mkDefault "${cfg.package}/etc/pulse/default.pa";
    }

    (mkIf cfg.enable {
      environment.systemPackages = [
        cfg.package
      ] ++ lib.optionals enable32BitAlsaPlugins [ pkgs_i686.pulseaudio ];

      environment.etc = singleton {
        target = "asound.conf";
        source = alsaConf;
      };

      # Allow PulseAudio to get realtime priority using rtkit.
      security.rtkit.enable = true;
    })

    (mkIf nonSystemWide {
      environment.etc = singleton {
        target = "pulse/default.pa";
        source = cfg.configFile;
      };
    })

    (mkIf systemWide {
      users.extraUsers.pulse = {
        # For some reason, PulseAudio wants UID == GID.
        uid = assert uid == gid; uid;
        group = "pulse";
        extraGroups = [ "audio" ];
        description = "PulseAudio system service user";
        home = stateDir;
        createHome = true;
      };

      users.extraGroups.pulse.gid = gid;

      systemd.services.pulseaudio = {
        description = "PulseAudio System-Wide Server";
        wantedBy = [ "sound.target" ];
        before = [ "sound.target" ];
        environment.PULSE_RUNTIME_PATH = stateDir;
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/pulseaudio -D --log-level=${cfg.daemon.logLevel} --system --use-pid-file -n --file=${cfg.configFile}";
          PIDFile = "${stateDir}/pid";
        };
      };
    })
  ];

}
