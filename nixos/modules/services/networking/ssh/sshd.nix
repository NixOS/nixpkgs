{ config, lib, pkgs, ... }:

with lib;

let

  cfg  = config.services.openssh;
  cfgc = config.programs.ssh;

  nssModulesPath = config.system.nssModules.path;

  userOptions = {

    openssh.authorizedKeys = {
      keys = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          A list of verbatim OpenSSH public keys that should be added to the
          user's authorized keys. The keys are added to a file that the SSH
          daemon reads in addition to the the user's authorized_keys file.
          You can combine the <literal>keys</literal> and
          <literal>keyFiles</literal> options.
          Warning: If you are using <literal>NixOps</literal> then don't use this
          option since it will replace the key required for deployment via ssh.
        '';
      };

      keyFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          A list of files each containing one OpenSSH public key that should be
          added to the user's authorized keys. The contents of the files are
          read at build time and added to a file that the SSH daemon reads in
          addition to the the user's authorized_keys file. You can combine the
          <literal>keyFiles</literal> and <literal>keys</literal> options.
        '';
      };
    };

  };

  authKeysFiles = let
    mkAuthKeyFile = u: nameValuePair "ssh/authorized_keys.d/${u.name}" {
      mode = "0444";
      source = pkgs.writeText "${u.name}-authorized_keys" ''
        ${concatStringsSep "\n" u.openssh.authorizedKeys.keys}
        ${concatMapStrings (f: readFile f + "\n") u.openssh.authorizedKeys.keyFiles}
      '';
    };
    usersWithKeys = attrValues (flip filterAttrs config.users.extraUsers (n: u:
      length u.openssh.authorizedKeys.keys != 0 || length u.openssh.authorizedKeys.keyFiles != 0
    ));
  in listToAttrs (map mkAuthKeyFile usersWithKeys);

in

{

  ###### interface

  options = {

    services.openssh = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the OpenSSH secure shell daemon, which
          allows secure remote logins.
        '';
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set, <command>sshd</command> is socket-activated; that
          is, instead of having it permanently running as a daemon,
          systemd will start an instance for each incoming connection.
        '';
      };

      forwardX11 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to allow X11 connections to be forwarded.
        '';
      };

      allowSFTP = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable the SFTP subsystem in the SSH daemon.  This
          enables the use of commands such as <command>sftp</command> and
          <command>sshfs</command>.
        '';
      };

      sftpFlags = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "-f AUTHPRIV" "-l INFO" ];
        description = ''
          Commandline flags to add to sftp-server.
        '';
      };

      permitRootLogin = mkOption {
        default = "prohibit-password";
        type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
        description = ''
          Whether the root user can login using ssh.
        '';
      };

      gatewayPorts = mkOption {
        type = types.str;
        default = "no";
        description = ''
          Specifies whether remote hosts are allowed to connect to
          ports forwarded for the client.  See
          <citerefentry><refentrytitle>sshd_config</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>.
        '';
      };

      ports = mkOption {
        type = types.listOf types.int;
        default = [22];
        description = ''
          Specifies on which ports the SSH daemon listens.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to automatically open the specified ports in the firewall.
        '';
      };

      listenAddresses = mkOption {
        type = with types; listOf (submodule {
          options = {
            addr = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Host, IPv4 or IPv6 address to listen to.
              '';
            };
            port = mkOption {
              type = types.nullOr types.int;
              default = null;
              description = ''
                Port to listen to.
              '';
            };
          };
        });
        default = [];
        example = [ { addr = "192.168.3.1"; port = 22; } { addr = "0.0.0.0"; port = 64022; } ];
        description = ''
          List of addresses and ports to listen on (ListenAddress directive
          in config). If port is not specified for address sshd will listen
          on all ports specified by <literal>ports</literal> option.
          NOTE: this will override default listening on all local addresses and port 22.
          NOTE: setting this option won't automatically enable given ports
          in firewall configuration.
        '';
      };

      passwordAuthentication = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Specifies whether password authentication is allowed.
        '';
      };

      challengeResponseAuthentication = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Specifies whether challenge/response authentication is allowed.
        '';
      };

      hostKeys = mkOption {
        type = types.listOf types.attrs;
        default =
          [ { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
            { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
          ];
        description = ''
          NixOS can automatically generate SSH host keys.  This option
          specifies the path, type and size of each key.  See
          <citerefentry><refentrytitle>ssh-keygen</refentrytitle>
          <manvolnum>1</manvolnum></citerefentry> for supported types
          and sizes.
        '';
      };

      authorizedKeysFiles = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Files from which authorized keys are read.";
      };

      kexAlgorithms = mkOption {
        type = types.listOf types.str;
        default = [
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];
        description = ''
          Allowed key exchange algorithms
          </para>
          <para>
          Defaults to recommended settings from both
          <link xlink:href="https://stribika.github.io/2015/01/04/secure-secure-shell.html" />
          and
          <link xlink:href="https://wiki.mozilla.org/Security/Guidelines/OpenSSH#Modern_.28OpenSSH_6.7.2B.29" />
        '';
      };

      ciphers = mkOption {
        type = types.listOf types.str;
        default = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
          "aes256-ctr"
          "aes192-ctr"
          "aes128-ctr"
        ];
        description = ''
          Allowed ciphers
          </para>
          <para>
          Defaults to recommended settings from both
          <link xlink:href="https://stribika.github.io/2015/01/04/secure-secure-shell.html" />
          and
          <link xlink:href="https://wiki.mozilla.org/Security/Guidelines/OpenSSH#Modern_.28OpenSSH_6.7.2B.29" />
        '';
      };

      macs = mkOption {
        type = types.listOf types.str;
        default = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-512"
          "hmac-sha2-256"
          "umac-128@openssh.com"
        ];
        description = ''
          Allowed MACs
          </para>
          <para>
          Defaults to recommended settings from both
          <link xlink:href="https://stribika.github.io/2015/01/04/secure-secure-shell.html" />
          and
          <link xlink:href="https://wiki.mozilla.org/Security/Guidelines/OpenSSH#Modern_.28OpenSSH_6.7.2B.29" />
        '';
      };

      logLevel = mkOption {
        type = types.enum [ "QUIET" "FATAL" "ERROR" "INFO" "VERBOSE" "DEBUG" "DEBUG1" "DEBUG2" "DEBUG3" ];
        default = "VERBOSE";
        description = ''
          Gives the verbosity level that is used when logging messages from sshd(8). The possible values are:
          QUIET, FATAL, ERROR, INFO, VERBOSE, DEBUG, DEBUG1, DEBUG2, and DEBUG3. The default is VERBOSE. DEBUG and DEBUG1
          are equivalent. DEBUG2 and DEBUG3 each specify higher levels of debugging output. Logging with a DEBUG level
          violates the privacy of users and is not recommended.

          LogLevel VERBOSE logs user's key fingerprint on login.
          Needed to have a clear audit track of which key was used to log in.
        '';
      };

      useDns = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Specifies whether sshd(8) should look up the remote host name, and to check that the resolved host name for
          the remote IP address maps back to the very same IP address.
          If this option is set to no (the default) then only addresses and not host names may be used in
          ~/.ssh/authorized_keys from and sshd_config Match Host directives.
        '';
      };

      tcpKeepAlive = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Specifies whether the system should send TCP keepalive messages to the other side. If they are sent, death of
          the connection or crash of one of the machines will be properly noticed. However, this means that connections
          will die if the route is down temporarily, and some people find it annoying. On the other hand, if
          TCP keepalives are not sent, sessions may hang indefinitely on the server, leaving “ghost” users and consuming
          server resources.
          The default is yes (to send TCP keepalive messages), and the server will notice if the network goes down or
          the client host crashes. This avoids infinitely hanging sessions.
          To disable TCP keepalive messages, the value should be set to no.
        '';
      };

      clientAliveCountMax = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = 5;
        description = ''
          Sets the number of client alive messages which may be sent without sshd(8) receiving any messages back from
          the client. If this threshold is reached while client alive messages are being sent, sshd will disconnect
          the client, terminating the session. It is important to note that the use of client alive messages is very
          different from TCPKeepAlive. The client alive messages are sent through the encrypted channel and therefore
          will not be spoofable. The TCP keepalive option enabled by TCPKeepAlive is spoofable. The client alive
          mechanism is valuable when the client or server depend on knowing when a connection has become inactive.
          The default value is 3. If ClientAliveInterval is set to 15, and ClientAliveCountMax is left at the default,
          unresponsive SSH clients will be disconnected after approximately 45 seconds.
        '';
      };

      clientAliveInterval = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = 15;
        description = ''
          Sets a timeout interval in seconds after which if no data has been received from the client, sshd(8) will send a
          message through the encrypted channel to request a response from the client. The default is 0, indicating
          that these messages will not be sent to the client.
        '';
      };

      maxStartups = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "3:30:9";
        description = ''
          Specifies the maximum number of concurrent unauthenticated connections to the SSH daemon. Additional
          connections will be dropped until authentication succeeds or the LoginGraceTime expires for a connection.
          The default is 10:30:100.
          Alternatively, random early drop can be enabled by specifying the three colon separated values
          start:rate:full (e.g. "10:30:60"). sshd(8) will refuse connection attempts with a probability of rate/100 (30%)
          if there are currently start (10) unauthenticated connections. The probability increases linearly and all
          connection attempts are refused if the number of unauthenticated connections reaches full (60).
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Verbatim contents of <filename>sshd_config</filename>.";
      };

      moduliFile = mkOption {
        example = "/etc/my-local-ssh-moduli;";
        type = types.path;
        description = ''
          Path to <literal>moduli</literal> file to install in
          <literal>/etc/ssh/moduli</literal>. If this option is unset, then
          the <literal>moduli</literal> file shipped with OpenSSH will be used.
        '';
      };

    };

    users.users = mkOption {
      options = [ userOptions ];
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers.sshd =
      { isSystemUser = true;
        description = "SSH privilege separation user";
      };

    services.openssh.moduliFile = mkDefault "${cfgc.package}/etc/ssh/moduli";

    environment.etc = authKeysFiles //
      { "ssh/moduli".source = cfg.moduliFile;
        "ssh/sshd_config".text = cfg.extraConfig;
      };

    systemd =
      let
        service =
          { description = "SSH Daemon";
            wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";
            after = [ "network.target" ];
            stopIfChanged = false;
            path = [ cfgc.package pkgs.gawk ];
            environment.LD_LIBRARY_PATH = nssModulesPath;

            preStart =
              ''
                # Make sure we don't write to stdout, since in case of
                # socket activation, it goes to the remote side (#19589).
                exec >&2

                mkdir -m 0755 -p /etc/ssh

                ${flip concatMapStrings cfg.hostKeys (k: ''
                  if ! [ -f "${k.path}" ]; then
                      ssh-keygen -t "${k.type}" ${if k ? bits then "-b ${toString k.bits}" else ""} -f "${k.path}" -N ""
                  fi
                '')}
              '';

            serviceConfig =
              { ExecStart =
                  (optionalString cfg.startWhenNeeded "-") +
                  "${cfgc.package}/bin/sshd " + (optionalString cfg.startWhenNeeded "-i ") +
                  "-f /etc/ssh/sshd_config";
                KillMode = "process";
              } // (if cfg.startWhenNeeded then {
                StandardInput = "socket";
                StandardError = "journal";
              } else {
                Restart = "always";
                Type = "simple";
              });
          };
      in

      if cfg.startWhenNeeded then {

        sockets.sshd =
          { description = "SSH Socket";
            wantedBy = [ "sockets.target" ];
            socketConfig.ListenStream = cfg.ports;
            socketConfig.Accept = true;
          };

        services."sshd@" = service;

      } else {

        services.sshd = service;

      };

    networking.firewall.allowedTCPPorts = if cfg.openFirewall then cfg.ports else [];

    security.pam.services.sshd =
      { startSession = true;
        showMotd = true;
        unixAuth = cfg.passwordAuthentication;
      };

    services.openssh.authorizedKeysFiles =
      [ ".ssh/authorized_keys" ".ssh/authorized_keys2" "/etc/ssh/authorized_keys.d/%u" ];

    services.openssh.extraConfig = mkOrder 0
      ''
        Protocol 2

        UsePAM yes

        AddressFamily ${if config.networking.enableIPv6 then "any" else "inet"}
        ${concatMapStrings (port: ''
          Port ${toString port}
        '') cfg.ports}

        ${concatMapStrings ({ port, addr, ... }: ''
          ListenAddress ${addr}${if port != null then ":" + toString port else ""}
        '') cfg.listenAddresses}

        ${if cfg.forwardX11
          then ''X11Forwarding yes''
          else ''X11Forwarding no''
        }
        ${optionalString cfgc.setXAuthLocation ''XAuthLocation ${pkgs.xorg.xauth}/bin/xauth''}

        ${optionalString cfg.allowSFTP ''
          Subsystem sftp ${cfgc.package}/libexec/sftp-server ${concatStringsSep " " cfg.sftpFlags}
        ''}

        PermitRootLogin ${cfg.permitRootLogin}
        GatewayPorts ${cfg.gatewayPorts}
        PasswordAuthentication ${if cfg.passwordAuthentication then "yes" else "no"}
        ChallengeResponseAuthentication ${if cfg.challengeResponseAuthentication then "yes" else "no"}

        PrintMotd no # handled by pam_motd

        AuthorizedKeysFile ${toString cfg.authorizedKeysFiles}

        ${flip concatMapStrings cfg.hostKeys (k: ''
          HostKey ${k.path}
        '')}

        KexAlgorithms ${concatStringsSep "," cfg.kexAlgorithms}
        Ciphers ${concatStringsSep "," cfg.ciphers}
        MACs ${concatStringsSep "," cfg.macs}

        LogLevel ${cfg.logLevel}

        ${if cfg.useDns
          then ''UseDNS yes''
          else ''UseDNS no''
        }
        ${if cfg. tcpKeepAlive
          then ''TCPKeepAlive yes''
          else ''TCPKeepAlive no''
        }
        ${optionalString (cfg.clientAliveCountMax != null) ''ClientAliveCountMax ${cfg.clientAliveCountMax}''}
        ${optionalString (cfg.clientAliveInterval != null) ''ClientAliveInterval ${cfg.clientAliveInterval}''}

        ${optionalString (cfg.maxStartups != null) ''MaxStartups ${toString cfg.maxStartups}''}

      '';

    assertions = [{ assertion = if cfg.forwardX11 then cfgc.setXAuthLocation else true;
                    message = "cannot enable X11 forwarding without setting xauth location";}]
      ++ flip map cfg.listenAddresses ({ addr, port, ... }: {
        assertion = addr != null;
        message = "addr must be specified in each listenAddresses entry";
      });

  };

}
