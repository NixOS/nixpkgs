{ config, lib, pkgs, ... }:

with lib;

let

  cfg  = config.services.openssh;
  cfgc = config.programs.ssh;

  nssModulesPath = config.system.nssModules.path;

  permitRootLoginCheck = v:
    v == "yes" ||
    v == "without-password" ||
    v == "forced-commands-only" ||
    v == "no";

  knownHosts = map (h: getAttr h cfg.knownHosts) (attrNames cfg.knownHosts);

  knownHostsFile = pkgs.runCommand "ssh_known_hosts" {} ''
    #!${pkgs.bash}/bin/bash
    ${flip concatMapStrings knownHosts (h: ''
      pubkeyfile=${builtins.toFile "host.pub" (if h.publicKey == null then readFile h.publicKeyFile else h.publicKey)}
      ${pkgs.gnused}/bin/sed 's/^/${concatStringsSep "," h.hostNames} /' $pubkeyfile >> $out
    '')}
  '';

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
    mkAuthKeyFile = u: {
      target = "ssh/authorized_keys.d/${u.name}";
      mode = "0444";
      source = pkgs.writeText "${u.name}-authorized_keys" ''
        ${concatStringsSep "\n" u.openssh.authorizedKeys.keys}
        ${concatMapStrings (f: readFile f + "\n") u.openssh.authorizedKeys.keyFiles}
      '';
    };
    usersWithKeys = attrValues (flip filterAttrs config.users.extraUsers (n: u:
      length u.openssh.authorizedKeys.keys != 0 || length u.openssh.authorizedKeys.keyFiles != 0
    ));
  in map mkAuthKeyFile usersWithKeys;

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
        default = cfgc.setXAuthLocation;
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
        default = "without-password";
        type = types.addCheck types.str permitRootLoginCheck;
        description = ''
          Whether the root user can login using ssh. Valid values are
          <literal>yes</literal>, <literal>without-password</literal>,
          <literal>forced-commands-only</literal> or
          <literal>no</literal>.
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
        type = types.listOf types.optionSet;
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
          [ { path = "/etc/ssh/ssh_host_dsa_key";
              type = "dsa";
              bits = 1024;
            }
            { path = "/etc/ssh/ssh_host_ecdsa_key";
              type = "ecdsa";
              bits = 521;
            }
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
        description = "Files from with authorized keys are read.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Verbatim contents of <filename>sshd_config</filename>.";
      };

      knownHosts = mkOption {
        default = {};
        type = types.loaOf types.optionSet;
        description = ''
          The set of system-wide known SSH hosts.
        '';
        example = [
          {
            hostNames = [ "myhost" "myhost.mydomain.com" "10.10.1.4" ];
            publicKeyFile = literalExample "./pubkeys/myhost_ssh_host_dsa_key.pub";
          }
          {
            hostNames = [ "myhost2" ];
            publicKeyFile = literalExample "./pubkeys/myhost2_ssh_host_dsa_key.pub";
          }
        ];
        options = {
          hostNames = mkOption {
            type = types.listOf types.string;
            default = [];
            description = ''
              A list of host names and/or IP numbers used for accessing
              the host's ssh service.
            '';
          };
          publicKey = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = ''
              The public key data for the host. You can fetch a public key
              from a running SSH server with the <command>ssh-keyscan</command>
              command. The public key should not include any host names, only
              the key type and the key itself. It is allowed to add several
              lines here, each line will be treated as type/key pair and the
              host names will be prepended to each line.
            '';
          };
          publicKeyFile = mkOption {
            default = null;
            type = types.nullOr types.path;
            description = ''
              The path to the public key file for the host. The public
              key file is read at build time and saved in the Nix store.
              You can fetch a public key file from a running SSH server
              with the <command>ssh-keyscan</command> command. The content
              of the file should follow the same format as described for
              the <literal>publicKey</literal> option.
            '';
          };
        };
      };

    };

    users.extraUsers = mkOption {
      options = [ userOptions ];
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = "sshd";
        uid = config.ids.uids.sshd;
        description = "SSH privilege separation user";
        home = "/var/empty";
      };

    environment.etc = authKeysFiles ++ [
      { source = "${cfgc.package}/etc/ssh/moduli";
        target = "ssh/moduli";
      }
      { source = knownHostsFile;
        target = "ssh/ssh_known_hosts";
      }
    ];

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
                mkdir -m 0755 -p /etc/ssh

                ${flip concatMapStrings cfg.hostKeys (k: ''
                  if ! [ -f "${k.path}" ]; then
                      ssh-keygen -t "${k.type}" -b "${toString k.bits}" -f "${k.path}" -N ""
                  fi
                '')}
              '';

            serviceConfig =
              { ExecStart =
                  "${cfgc.package}/sbin/sshd " + (optionalString cfg.startWhenNeeded "-i ") +
                  "-f ${pkgs.writeText "sshd_config" cfg.extraConfig}";
                KillMode = "process";
              } // (if cfg.startWhenNeeded then {
                StandardInput = "socket";
              } else {
                Restart = "always";
                Type = "forking";
                PIDFile = "/run/sshd.pid";
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

    services.openssh.extraConfig =
      ''
        PidFile /run/sshd.pid

        Protocol 2

        UsePAM yes

        AddressFamily ${if config.networking.enableIPv6 then "any" else "inet"}
        ${concatMapStrings (port: ''
          Port ${toString port}
        '') cfg.ports}

        ${concatMapStrings ({ port, addr }: ''
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
      '';

    assertions = [{ assertion = if cfg.forwardX11 then cfgc.setXAuthLocation else true;
                    message = "cannot enable X11 forwarding without setting xauth location";}]
      ++ flip mapAttrsToList cfg.knownHosts (name: data: {
        assertion = (data.publicKey == null && data.publicKeyFile != null) ||
                    (data.publicKey != null && data.publicKeyFile == null);
        message = "knownHost ${name} must contain either a publicKey or publicKeyFile";
      })
      ++ flip map cfg.listenAddresses ({ addr, port }: {
        assertion = addr != null;
        message = "addr must be specified in each listenAddresses entry";
      });

  };

}
