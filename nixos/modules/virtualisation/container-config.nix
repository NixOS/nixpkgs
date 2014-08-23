{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf config.boot.isContainer {

    # Disable some features that are not useful in a container.
    sound.enable = mkDefault false;
    services.udisks2.enable = mkDefault false;

    networking.useHostResolvConf = true;

    # Containers should be light-weight, so start sshd on demand.
    services.openssh.startWhenNeeded = mkDefault true;

    # Shut up warnings about not having a boot loader.
    system.build.installBootLoader = "${pkgs.coreutils}/bin/true";

    # Provide a root login prompt on /var/lib/root-login.socket that
    # doesn't ask for a password. This socket can only be used by root
    # on the host.
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

    systemd.services.systemd-remount-fs.enable = false;

  };

}
