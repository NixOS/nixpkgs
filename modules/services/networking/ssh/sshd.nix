{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      sshd = {

        enable = mkOption {
          default = false;
          description = "
            Whether to enable the Secure Shell daemon, which allows secure
            remote logins.
          ";
        };

        forwardX11 = mkOption {
          default = true;
          description = "
            Whether to enable sshd to forward X11 connections.
          ";
        };

        allowSFTP = mkOption {
          default = true;
          description = "
            Whether to enable the SFTP subsystem in the SSH daemon.  This
            enables the use of commands such as <command>sftp</command> and
            <command>sshfs</command>.
          ";
        };

        permitRootLogin = mkOption {
          default = "yes";
          description = "
            Whether the root user can login using ssh. Valid options
            are <command>yes</command>, <command>without-password</command>,
            <command>forced-commands-only</command> or
            <command>no</command>
          ";
        };

        gatewayPorts = mkOption {
          default = "no";
          description = "
             Specifies whether remote hosts are allowed to connect to ports forwarded for the client. See man sshd_conf.
            ";
          };
      };
    };
  };

###### implementation

  inherit (pkgs) writeText openssh;

  cfg = (config.services.sshd);

  nssModules = config.system.nssModules.list;

  nssModulesPath = config.system.nssModules.path;

  sshdConfig = writeText "sshd_config" ''

    Protocol 2
    
    UsePAM yes
    
    ${if cfg.forwardX11 then "
      X11Forwarding yes
      XAuthLocation ${pkgs.xlibs.xauth}/bin/xauth
    " else "
      X11Forwarding no
    "}

    ${if cfg.allowSFTP then "
      Subsystem sftp ${openssh}/libexec/sftp-server
    " else "
    "}
    
    PermitRootLogin ${cfg.permitRootLogin}
    GatewayPorts ${cfg.gatewayPorts}
    
  '';

  # !!! is this assertion evaluated anywhere???
  assertion = cfg.permitRootLogin == "yes" ||
       cfg.permitRootLogin == "without-password" ||
       cfg.permitRootLogin == "forced-commands-only" ||
       cfg.permitRootLogin == "no";

in


mkIf config.services.sshd.enable {
  require = [
    options
  ];

  users = {
    extraUsers = [
      { name = "sshd";
        uid = config.ids.uids.sshd;
        description = "SSH privilege separation user";
        home = "/var/empty";
      }
    ];
  };

  services = {
    extraJobs = [{
      name = "sshd";

      job = ''
        description "SSH server"

        start on network-interfaces/started
        stop on network-interfaces/stop

        env LD_LIBRARY_PATH=${nssModulesPath}

        start script
            mkdir -m 0755 -p /etc/ssh

            if ! test -f /etc/ssh/ssh_host_dsa_key; then
                ${openssh}/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ""
            fi
        end script

        respawn ${openssh}/sbin/sshd -D -h /etc/ssh/ssh_host_dsa_key -f ${sshdConfig}
      '';
    }];
  };
}
