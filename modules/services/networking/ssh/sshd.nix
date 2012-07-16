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

      preserveExistingKeys = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If this option is enabled, the keys specified in
          <literal>keys</literal> and/or <literal>keyFiles</literal> will be
          placed in a special section of the user's authorized_keys file
          and any existing keys will be preserved. That section will be
          regenerated each time NixOS is activated. However, if
          <literal>preserveExisting</literal> isn't enabled, the complete file
          will be generated, and any user modifications will be wiped out.
        '';
      };

      keys = mkOption {
        type = types.listOf types.string;
        default = [];
        description = ''
          A list of verbatim OpenSSH public keys that should be inserted into the
          user's authorized_keys file. You can combine the <literal>keys</literal> and
          <literal>keyFiles</literal> options.
        '';
      };

      keyFiles = mkOption {
        #type = types.listOf types.string;
        default = [];
        description = ''
          A list of files each containing one OpenSSH public keys that should be
          inserted into the user's authorized_keys file. You can combine
          the <literal>keyFiles</literal> and
          <literal>keys</literal> options.
        '';
      };

    };
    
  };

  mkAuthkeyScript =
    let
      marker1 = "### NixOS auto-added key. Do not edit!";
      marker2 = "### NixOS will regenerate this file. Do not edit!";
      users = map (userName: getAttr userName config.users.extraUsers) (attrNames config.users.extraUsers);
      usersWithKeys = flip filter users (u:
        length u.openssh.authorizedKeys.keys != 0 || length u.openssh.authorizedKeys.keyFiles != 0
      );
      userLoop = flip concatMapStrings usersWithKeys (u:
        let
          authKeys = concatStringsSep "," u.openssh.authorizedKeys.keys;
          authKeyFiles = concatStrings (map (x: " ${x}") u.openssh.authorizedKeys.keyFiles);
          preserveExisting = if u.openssh.authorizedKeys.preserveExistingKeys then "true" else "false";
        in ''
          mkAuthKeysFile "${u.name}" "${authKeys}" "${authKeyFiles}" "${preserveExisting}"
        ''
      );
    in ''
      mkAuthKeysFile() {
        local userName="$1"
        local authKeys="$2"
        local authKeyFiles="$3"
        local preserveExisting="$4"

        eval homeDir=~$userName
        if ! [ -d "$homeDir" ]; then
          echo "User $userName does not exist"
          return
        fi
        if ! [ -d "$homeDir/.ssh" ]; then
          mkdir -v -m 700 "$homeDir/.ssh"
          chown "$userName":users "$homeDir/.ssh"
        fi
        local authKeysFile="$homeDir/.ssh/authorized_keys"
        touch "$authKeysFile"
        if [ "$preserveExisting" == false ]; then
          rm -f "$authKeysFile"
          echo "${marker2}" > "$authKeysFile"
        else
          sed -i '/${marker1}/ d' "$authKeysFile"
        fi
        IFS=,
        for f in $authKeys; do
          echo "$f ${marker1}" >> "$authKeysFile"
        done
        unset IFS
        for f in $authKeyFiles; do
          if [ -f "$f" ]; then
            echo "$(cat "$f") ${marker1}" >> "$authKeysFile"
          fi
        done
        chown "$userName" "$authKeysFile"
      }

      ${userLoop}
    '';

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

    environment.etc = [
      { source = "${pkgs.openssh}/etc/ssh/moduli";
        target = "ssh/moduli";
      }
      { source = knownHostsFile;
        target = "ssh/ssh_known_hosts";
      }
    ];

    boot.systemd.services."set-ssh-keys.service" =
      { description = "Update authorized SSH keys";

        wantedBy = [ "multi-user.target" ];

        script = mkAuthkeyScript;

        serviceConfig =
          ''
            Type=oneshot
            RemainAfterExit=true
          '';
      };
    
    boot.systemd.services."sshd.service" =
      { description = "SSH daemon";

        wantedBy = [ "multi-user.target" ];
        after = [ "set-ssh-keys.service" ];

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
          ''
            ExecStart=\
              ${pkgs.openssh}/sbin/sshd -h ${cfg.hostKeyPath} \
                -f ${pkgs.writeText "sshd_config" cfg.extraConfig}
            Restart=always
            Type=forking
            KillMode=process
            PIDFile=/run/sshd.pid
          '';
      };

    networking.firewall.allowedTCPPorts = cfg.ports;

    services.openssh.extraConfig =
      ''
        PidFile /run/sshd.pid
      
        Protocol 2

        UsePAM ${if cfg.usePAM then "yes" else "no"}

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
      '';

    assertions = [{ assertion = if cfg.forwardX11 then cfgc.setXAuthLocation else true;
                    message = "cannot enable X11 forwarding without setting xauth location";}];
  };

}
