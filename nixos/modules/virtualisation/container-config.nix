{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.boot.isContainer {

    sound.enable = mkDefault false;

    # Provide a login prompt on /var/lib/login.socket.  On the host,
    # you can connect to it by running ‘socat
    # unix:<path-to-container>/var/lib/login.socket -,echo=0,raw’.
    systemd.sockets.login =
      { description = "Login Socket";
        wantedBy = [ "sockets.target" ];
        socketConfig =
          { ListenStream = "/var/lib/login.socket";
            SocketMode = "0666";
            Accept = true;
          };
      };

    systemd.services."login@" =
      { description = "Login %i";
        environment.TERM = "linux";
        serviceConfig =
          { Type = "simple";
            StandardInput = "socket";
            ExecStart = "${pkgs.socat}/bin/socat -t0 - exec:${pkgs.shadow}/bin/login,pty,setsid,setpgid,stderr,ctty";
            TimeoutStopSec = 1; # FIXME
          };
        restartIfChanged = false;
      };

    # Also provide a root login prompt on /var/lib/root-login.socket
    # that doesn't ask for a password. This socket can only be used by
    # root on the host.
    systemd.sockets.root-login =
      { description = "Root Login Socket";
        wantedBy = [ "sockets.target" ];
        socketConfig =
          { ListenStream = "/var/lib/root-login.socket";
            SocketMode = "0600";
            Accept = true;
          };
      };

    systemd.services."root-login@" =
      { description = "Root Login %i";
        environment.TERM = "linux";
        serviceConfig =
          { Type = "simple";
            StandardInput = "socket";
            ExecStart = "${pkgs.socat}/bin/socat -t0 - \"exec:${pkgs.shadow}/bin/login -f root,pty,setsid,setpgid,stderr,ctty\"";
            TimeoutStopSec = 1; # FIXME
          };
        restartIfChanged = false;
      };

    # Provide a daemon on /var/lib/run-command.socket that reads a
    # command from stdin and executes it.
    systemd.sockets.run-command =
      { description = "Run Command Socket";
        wantedBy = [ "sockets.target" ];
        socketConfig =
          { ListenStream = "/var/lib/run-command.socket";
            SocketMode = "0600";  # only root can connect
            Accept = true;
          };
      };

    systemd.services."run-command@" =
      { description = "Run Command %i";
        environment.TERM = "linux";
        serviceConfig =
          { Type = "simple";
            StandardInput = "socket";
            TimeoutStopSec = 1; # FIXME
          };
        script =
          ''
            #! ${pkgs.stdenv.shell} -e
            source /etc/bashrc
            read c
            eval "command=($c)"
            exec "''${command[@]}"
          '';
        restartIfChanged = false;
      };

    systemd.services.container-startup-done =
      { description = "Container Startup Notification";
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        script =
          ''
            if [ -p /var/lib/startup-done ]; then
              echo done > /var/lib/startup-done
            fi
          '';
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        restartIfChanged = false;
      };

  };

}
