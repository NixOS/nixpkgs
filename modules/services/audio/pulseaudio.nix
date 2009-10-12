{ config, pkgs, ... }:

with pkgs.lib;

let

  uid = config.ids.uids.pulseaudio;
  gid = config.ids.gids.pulseaudio;

in

{

  ###### interface

  options = {
  
    services.pulseaudio = {
    
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
  

  ###### implementation

  config = mkIf config.services.pulseaudio.enable {

    environment.systemPackages = [ pkgs.pulseaudio ];

    users.extraUsers = singleton
      { name = "pulse";
        # For some reason, PulseAudio wants UID == GID.
        uid = assert uid == gid; uid;
        group = "pulse";
        description = "PulseAudio system-wide daemon";
        home = "/var/run/pulse";
      };

    users.extraGroups = singleton
      { name = "pulse";
        inherit gid;
      };

    jobs.pulseaudio =
      { description = "PulseAudio system-wide server";

        startOn = "startup";
        stopOn = "shutdown";

        preStart =
          ''
            test -d /var/run/pulse ||			\
            ( mkdir -p --mode 755 /var/run/pulse &&	\
              chown pulse:pulse /var/run/pulse )
          '';

        exec =
          ''
            ${pkgs.pulseaudio}/bin/pulseaudio           \
              --system --daemonize                      \
              --log-level="${config.services.pulseaudio.logLevel}"
          '';
      };

  };
  
}
