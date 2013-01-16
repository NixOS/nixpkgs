{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg  = config.services.openssh;
  cfgc = config.programs.ssh;

  nssModulesPath = config.system.nssModules.path;

  permitRootLoginCheck = v:
    v == "yes" ||
    v == "without-password" ||
    v == "forced-commands-only" ||
    v == "no";

  hostKeyTypeNames = {
    dsa1024  = "dsa";
    rsa1024  = "rsa";
    ecdsa521 = "ecdsa";
  };

  hostKeyTypeBits = {
    dsa1024  = 1024;
    rsa1024  = 1024;
    ecdsa521 = 521;
  };

  hktn = attrByPath [cfg.hostKeyType] (throw "unknown host key type `${cfg.hostKeyType}'") hostKeyTypeNames;
  hktb = attrByPath [cfg.hostKeyType] (throw "unknown host key type `${cfg.hostKeyType}'") hostKeyTypeBits;

  knownHosts = map (h: getAttr h cfg.knownHosts) (attrNames cfg.knownHosts);

  knownHostsFile = pkgs.writeText "ssh_known_hosts" (
    flip concatMapStrings knownHosts (h:
      "${concatStringsSep "," h.hostNames} ${builtins.readFile h.publicKeyFile}"
    )
  );

  userOptions = {

    openssh.authorizedKeys = {
      keys = mkOption {
        type = types.listOf types.string;
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
        ${concatMapStrings (f: builtins.readFile f + "\n") u.openssh.authorizedKeys.keyFiles}
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
        default = false;
        description = ''
          Whether to enable the OpenSSH secure shell daemon, which
          allows secure remote logins.
        '';
      };

      forwardX11 = mkOption {
        default = cfgc.setXAuthLocation;
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
        default = "without-password";
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

      ports = mkOption {
        default = [22];
        description = ''
          Specifies on which ports the SSH daemon listens.
        '';
      };

      usePAM = mkOption {
        default = true;
        description = ''
          Specifies whether the OpenSSH daemon uses PAM to authenticate
          login attempts.
        '';
      };

      passwordAuthentication = mkOption {
        default = true;
        description = ''
          Specifies whether password authentication is allowed. Note
          that setting this value to <literal>false</literal> is most
          probably not going to have the desired effect unless
          <literal>usePAM</literal> is disabled as well.
        '';
      };

      challengeResponseAuthentication = mkOption {
        default = true;
        description = ''
          Specifies whether challenge/response authentication is allowed.
        '';
      };

      hostKeyType = mkOption {
        default = "dsa1024";
        description = ''
          Type of host key to generate (dsa1024/rsa1024/ecdsa521), if
          the file specified by <literal>hostKeyPath</literal> does not
          exist when the service starts.
        '';
      };

      hostKeyPath = mkOption {
        default = "/etc/ssh/ssh_host_${hktn}_key";
        description = ''
          Path to the server's private key. If there is no key file
          on this path, it will be generated when the service is
          started for the first time. Otherwise, the ssh daemon will
          use the specified key directly in-place.
        '';
      };

      authorizedKeysFiles = mkOption {
        default = [];
        description = "Files from with authorized keys are read.";
      };

      extraConfig = mkOption {
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
            publicKeyFile = ./pubkeys/myhost_ssh_host_dsa_key.pub;
          }
          {
            hostNames = [ "myhost2" ];
            publicKeyFile = ./pubkeys/myhost2_ssh_host_dsa_key.pub;
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
          publicKeyFile = mkOption {
            description = ''
              The path to the public key file for the host. The public
              key file is read at build time and saved in the Nix store.
              You can fetch a public key file from a running SSH server
              with the <literal>ssh-keyscan</literal> command.
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

  config = mkIf config.services.openssh.enable {

    users.extraUsers = singleton
      { name = "sshd";
        uid = config.ids.uids.sshd;
        description = "SSH privilege separation user";
        home = "/var/empty";
      };

    environment.etc = authKeysFiles ++ [
      { source = "${pkgs.openssh}/etc/ssh/moduli";
        target = "ssh/moduli";
      }
      { source = knownHostsFile;
        target = "ssh/ssh_known_hosts";
      }
    ];

    systemd.services.sshd =
      { description = "SSH Daemon";

        wantedBy = [ "multi-user.target" ];

        stopIfChanged = false;

        path = [ pkgs.openssh ];

        environment.LD_LIBRARY_PATH = nssModulesPath;
        environment.LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";

        preStart =
          ''
            mkdir -m 0755 -p /etc/ssh

            if ! test -f ${cfg.hostKeyPath}; then
                ssh-keygen -t ${hktn} -b ${toString hktb} -f ${cfg.hostKeyPath} -N ""
            fi
          '';

        serviceConfig =
          { ExecStart =
              "${pkgs.openssh}/sbin/sshd -h ${cfg.hostKeyPath} " +
              "-f ${pkgs.writeText "sshd_config" cfg.extraConfig}";
            Restart = "always";
            Type = "forking";
            KillMode = "process";
            PIDFile = "/run/sshd.pid";
          };
      };

    networking.firewall.allowedTCPPorts = cfg.ports;

    security.pam.services = optional cfg.usePAM { name = "sshd"; startSession = true; showMotd = true; };

    services.openssh.authorizedKeysFiles =
      [ ".ssh/authorized_keys" ".ssh/authorized_keys2" "/etc/ssh/authorized_keys.d/%u" ];

    services.openssh.extraConfig =
      ''
        PidFile /run/sshd.pid

        Protocol 2

        UsePAM ${if cfg.usePAM then "yes" else "no"}

        AddressFamily ${if config.networking.enableIPv6 then "any" else "inet"}
        ${concatMapStrings (port: ''
          Port ${toString port}
        '') cfg.ports}

        ${optionalString cfgc.setXAuthLocation ''
            XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
        ''}

        ${if cfg.forwardX11 then ''
          X11Forwarding yes
        '' else ''
          X11Forwarding no
        ''}

        ${optionalString cfg.allowSFTP ''
          Subsystem sftp ${pkgs.openssh}/libexec/sftp-server
        ''}

        PermitRootLogin ${cfg.permitRootLogin}
        GatewayPorts ${cfg.gatewayPorts}
        PasswordAuthentication ${if cfg.passwordAuthentication then "yes" else "no"}
        ChallengeResponseAuthentication ${if cfg.challengeResponseAuthentication then "yes" else "no"}

        PrintMotd no # handled by pam_motd

        AuthorizedKeysFile ${toString cfg.authorizedKeysFiles}
      '';

    assertions = [{ assertion = if cfg.forwardX11 then cfgc.setXAuthLocation else true;
                    message = "cannot enable X11 forwarding without setting xauth location";}];

  };

}
