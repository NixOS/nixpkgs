{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  uid = config.ids.uids.pulseaudio;
  gid = config.ids.gids.pulseaudio;

  options = {
    services = {
      pulseaudio = {
        enable = mkOption {
          default = false;
          description = ''
            Whether to enable the PulseAudio system-wide audio server.
            Note that the documentation recommends running PulseAudio
            daemons per-user rather than system-wide on desktop machines.
          '';
        };

        logLevel = mkOption {
          default = "notice";
          example = "debug";
          description = ''
            A string denoting the log level: one of
            <literal>error</literal>, <literal>warn</literal>,
            <literal>notice</literal>, <literal>info</literal>,
            or <literal>debug</literal>.
          '';
        };
      };
    };
  };
in

###### implementation


mkIf config.services.pulseaudio.enable {
  require = [
    options
  ];

  environment = {
    systemPackages = [pkgs.pulseaudio];
  };

  users = {
    extraUsers = [
      { name = "pulse";
        # For some reason, PulseAudio wants UID == GID.
        uid = assert uid == gid; uid;
        group = "pulse";
        description = "PulseAudio system-wide daemon";
        home = "/var/run/pulse";
      }
    ];

    extraGroups = [
      { name = "pulse";
        inherit gid;
      }
    ];
  };

  services = {
    extraJobs = [{
      name = "pulseaudio";

      job = ''
        description "PulseAudio system-wide server"

        start on startup
        stop on shutdown

        start script
          test -d /var/run/pulse ||			\
          ( mkdir -p --mode 755 /var/run/pulse &&	\
            chown pulse:pulse /var/run/pulse )
        end script

        respawn ${pkgs.pulseaudio}/bin/pulseaudio               \
          --system --daemonize                                  \
          --log-level="${config.services.pulseaudio.logLevel}"
      '';
    }];
  };
}
