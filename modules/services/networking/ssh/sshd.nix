{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.openssh;

  nssModulesPath = config.system.nssModules.path;

  sshdConfig = pkgs.writeText "sshd_config"
    ''
      Protocol 2

      UsePAM yes

      ${ concatMapStrings (port : ''Port ${toString port}
                                           '') cfg.ports}

      ${if cfg.forwardX11 then "
        X11Forwarding yes
        XAuthLocation ${pkgs.xlibs.xauth}/bin/xauth
      " else "
        X11Forwarding no
      "}

      ${if cfg.allowSFTP then "
        Subsystem sftp ${pkgs.openssh}/libexec/sftp-server
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
  
    services.openssh = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the OpenSSH secure shell daemon, which
          allows secure remote logins.
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
          If without-password doesn't work try <literal>yes</literal>.
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

      ports = mkOption {
        default = [22];
        description = ''
          Specifies on which ports the SSH daemon listens.
        '';
      };
      
    };

  };


  ###### implementation

  config = mkIf config.services.openssh.enable {

    users.extraUsers = singleton
      { name = "sshd";
        uid = config.ids.uids.sshd;
        description = "SSH privilege separation user";
        home = "/var/empty";
      };

    environment.etc = singleton
      { source = "${pkgs.openssh}/etc/ssh/moduli";
        target = "ssh/moduli";
      };

    jobs.sshd = {

        description = "OpenSSH server";

        startOn = "started network-interfaces";

        environment = { LD_LIBRARY_PATH = nssModulesPath; };

        preStart =
          ''
            mkdir -m 0755 -p /etc/ssh

            if ! test -f /etc/ssh/ssh_host_dsa_key; then
                ${pkgs.openssh}/bin/ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ""
            fi
          '';

        daemonType = "fork";

        exec = "${pkgs.openssh}/sbin/sshd -h /etc/ssh/ssh_host_dsa_key -f ${sshdConfig}";
      };

    networking.firewall.allowedTCPPorts = cfg.ports;
  };

}
