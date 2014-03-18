{ config, pkgs, ... }:

{

  config = {

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
      };

    # Provide a non-interactive login root shell on
    # /var/lib/root-shell.socket.  On the host, you can connect to it
    # by running ‘socat unix:<path-to-container>/var/lib/root-shell.socket -’.
    systemd.sockets.root-shell =
      { description = "Root Shell Socket";
        wantedBy = [ "sockets.target" ];
        socketConfig =
          { ListenStream = "/var/lib/root-shell.socket";
            SocketMode = "0600"; # only root can connect, obviously
            Accept = true;
          };
      };

    systemd.services."root-shell@" =
      { description = "Root Shell %i";
        serviceConfig =
          { Type = "simple";
            StandardInput = "socket";
            ExecStart = "${pkgs.bash}/bin/bash --login";
            TimeoutStopSec = 1; # FIXME
          };
      };

  };

}
