{pkgs, config, ...}:

let

  inherit (pkgs.lib) mkOption mkIf;
  inherit (pkgs) openssh;

  cfg = config.services.sshd;

  nssModulesPath = config.system.nssModules.path;

  sshdConfig = pkgs.writeText "sshd_config"
    ''
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

  permitRootLoginCheck = v:
    v == "yes" ||
    v == "without-password" ||
    v == "forced-commands-only" ||
    v == "no";

in

{

  ###### interface
  
  options = {
  
    services.sshd = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the Secure Shell daemon, which allows secure
          remote logins.
        '';
      };

      forwardX11 = mkOption {
        default = true;
        description = ''
          Whether to allow X11 connections to be forwarded.
        '';
      };

      allowSFTP = mkOption {
        default = true;
        description = ''
          Whether to enable the SFTP subsystem in the SSH daemon.  This
          enables the use of commands such as <command>sftp</command> and
          <command>sshfs</command>.
        '';
      };

      permitRootLogin = mkOption {
        default = "yes";
        check = permitRootLoginCheck;
        description = ''
          Whether the root user can login using ssh. Valid values are
          <literal>yes</literal>, <literal>without-password</literal>,
          <literal>forced-commands-only</literal> or
          <literal>no</literal>.
        '';
      };

      gatewayPorts = mkOption {
        default = "no";
        description = ''
          Specifies whether remote hosts are allowed to connect to
          ports forwarded for the client.  See
          <citerefentry><refentrytitle>sshd_config</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>.
        '';
      };
      
    };

  };


  ###### implementation

  config = mkIf config.services.sshd.enable {

    users.extraUsers = pkgs.lib.singleton
      { name = "sshd";
        uid = config.ids.uids.sshd;
        description = "SSH privilege separation user";
        home = "/var/empty";
      };

    jobs.sshd = {

        description = "OpenSSH server";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        environment = { LD_LIBRARY_PATH = nssModulesPath; };

        preStart =
          ''
            mkdir -m 0755 -p /etc/ssh

            if ! test -f /etc/ssh/ssh_host_dsa_key; then
                ${openssh}/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ""
            fi
          '';

        exec = "${openssh}/sbin/sshd -D -h /etc/ssh/ssh_host_dsa_key -f ${sshdConfig}";
      };

    networking.firewall.allowedTCPPorts = [22];
          
  };

}
