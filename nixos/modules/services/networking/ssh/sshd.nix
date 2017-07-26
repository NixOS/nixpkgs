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

  supportOldHostKeys = !versionAtLeast config.system.stateVersion "15.07";

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
          ] ++ optionals supportOldHostKeys
          [ { type = "dsa"; path = "/etc/ssh/ssh_host_dsa_key"; }
            { type = "ecdsa"; bits = 521; path = "/etc/ssh/ssh_host_ecdsa_key"; }
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Verbatim contents of <filename>sshd_config</filename>.";
      };

      moduliFile = mkOption {
        example = "services.openssh.moduliFile = /etc/my-local-ssh-moduli;";
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
      { "ssh/moduli".source = cfg.moduliFile; };

    systemd =
      let
        service =
          { description = "SSH Daemon";

            wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";

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
                  "-f ${pkgs.writeText "sshd_config" cfg.extraConfig}";
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

    networking.firewall.allowedTCPPorts = cfg.ports;

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

        ${optionalString cfgc.setXAuthLocation ''
            XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
        ''}

        ${if cfg.forwardX11 then ''
          X11Forwarding yes
        '' else ''
          X11Forwarding no
        ''}

        ${optionalString cfg.allowSFTP ''
          Subsystem sftp ${cfgc.package}/libexec/sftp-server
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

        # Allow DSA client keys for now. (These were deprecated
        # in OpenSSH 7.0.)
        PubkeyAcceptedKeyTypes +ssh-dss

        # Re-enable DSA host keys for now.
        ${optionalString supportOldHostKeys ''
          HostKeyAlgorithms +ssh-dss
        ''}
      '';

    assertions = [{ assertion = if cfg.forwardX11 then cfgc.setXAuthLocation else true;
                    message = "cannot enable X11 forwarding without setting xauth location";}]
      ++ flip map cfg.listenAddresses ({ addr, port, ... }: {
        assertion = addr != null;
        message = "addr must be specified in each listenAddresses entry";
      });

  };

}
