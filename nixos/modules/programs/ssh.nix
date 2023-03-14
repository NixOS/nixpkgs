# Global configuration for the SSH client.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg  = config.programs.ssh;

  askPassword = cfg.askPassword;

  askPasswordWrapper = pkgs.writeScript "ssh-askpass-wrapper"
    ''
      #! ${pkgs.runtimeShell} -e
      export DISPLAY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^DISPLAY=\(.*\)/\1/; t; d')"
      export WAYLAND_DISPLAY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^WAYLAND_DISPLAY=\(.*\)/\1/; t; d')"
      exec ${askPassword} "$@"
    '';

  knownHosts = attrValues cfg.knownHosts;

  knownHostsText = (flip (concatMapStringsSep "\n") knownHosts
    (h: assert h.hostNames != [];
      optionalString h.certAuthority "@cert-authority " + concatStringsSep "," h.hostNames + " "
      + (if h.publicKey != null then h.publicKey else readFile h.publicKeyFile)
    )) + "\n";

  knownHostsFiles = [ "/etc/ssh/ssh_known_hosts" "/etc/ssh/ssh_known_hosts2" ]
    ++ map pkgs.copyPathToStore cfg.knownHostsFiles;

in
{
  ###### interface

  options = {

    programs.ssh = {

      enableAskPassword = mkOption {
        type = types.bool;
        default = config.services.xserver.enable;
        defaultText = literalExpression "config.services.xserver.enable";
        description = lib.mdDoc "Whether to configure SSH_ASKPASS in the environment.";
      };

      askPassword = mkOption {
        type = types.str;
        default = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
        defaultText = literalExpression ''"''${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass"'';
        description = lib.mdDoc "Program used by SSH to ask for passwords.";
      };

      forwardX11 = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to request X11 forwarding on outgoing connections by default.
          This is useful for running graphical programs on the remote machine and have them display to your local X11 server.
          Historically, this value has depended on the value used by the local sshd daemon, but there really isn't a relation between the two.
          Note: there are some security risks to forwarding an X11 connection.
          NixOS's X server is built with the SECURITY extension, which prevents some obvious attacks.
          To enable or disable forwarding on a per-connection basis, see the -X and -x options to ssh.
          The -Y option to ssh enables trusted forwarding, which bypasses the SECURITY extension.
        '';
      };

      setXAuthLocation = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          Whether to set the path to {command}`xauth` for X11-forwarded connections.
          This causes a dependency on X11 packages.
        '';
      };

      pubkeyAcceptedKeyTypes = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "ssh-ed25519" "ssh-rsa" ];
        description = lib.mdDoc ''
          Specifies the key types that will be used for public key authentication.
        '';
      };

      hostKeyAlgorithms = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "ssh-ed25519" "ssh-rsa" ];
        description = lib.mdDoc ''
          Specifies the host key algorithms that the client wants to use in order of preference.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra configuration text prepended to {file}`ssh_config`. Other generated
          options will be added after a `Host *` pattern.
          See {manpage}`ssh_config(5)`
          for help.
        '';
      };

      startAgent = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to start the OpenSSH agent when you log in.  The OpenSSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          {command}`ssh-add` to add a key to the agent.
        '';
      };

      agentTimeout = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "1h";
        description = lib.mdDoc ''
          How long to keep the private keys in memory. Use null to keep them forever.
        '';
      };

      agentPKCS11Whitelist = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = literalExpression ''"''${pkgs.opensc}/lib/opensc-pkcs11.so"'';
        description = lib.mdDoc ''
          A pattern-list of acceptable paths for PKCS#11 shared libraries
          that may be used with the -s option to ssh-add.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.openssh;
        defaultText = literalExpression "pkgs.openssh";
        description = lib.mdDoc ''
          The package used for the openssh client and daemon.
        '';
      };

      knownHosts = mkOption {
        default = {};
        type = types.attrsOf (types.submodule ({ name, config, options, ... }: {
          options = {
            certAuthority = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                This public key is an SSH certificate authority, rather than an
                individual host's key.
              '';
            };
            hostNames = mkOption {
              type = types.listOf types.str;
              default = [ name ] ++ config.extraHostNames;
              defaultText = literalExpression "[ ${name} ] ++ config.${options.extraHostNames}";
              description = lib.mdDoc ''
                A list of host names and/or IP numbers used for accessing
                the host's ssh service. This list includes the name of the
                containing `knownHosts` attribute by default
                for convenience. If you wish to configure multiple host keys
                for the same host use multiple `knownHosts`
                entries with different attribute names and the same
                `hostNames` list.
              '';
            };
            extraHostNames = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc ''
                A list of additional host names and/or IP numbers used for
                accessing the host's ssh service. This list is ignored if
                `hostNames` is set explicitly.
              '';
            };
            publicKey = mkOption {
              default = null;
              type = types.nullOr types.str;
              example = "ecdsa-sha2-nistp521 AAAAE2VjZHN...UEPg==";
              description = lib.mdDoc ''
                The public key data for the host. You can fetch a public key
                from a running SSH server with the {command}`ssh-keyscan`
                command. The public key should not include any host names, only
                the key type and the key itself.
              '';
            };
            publicKeyFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = lib.mdDoc ''
                The path to the public key file for the host. The public
                key file is read at build time and saved in the Nix store.
                You can fetch a public key file from a running SSH server
                with the {command}`ssh-keyscan` command. The content
                of the file should follow the same format as described for
                the `publicKey` option. Only a single key
                is supported. If a host has multiple keys, use
                {option}`programs.ssh.knownHostsFiles` instead.
              '';
            };
          };
        }));
        description = lib.mdDoc ''
          The set of system-wide known SSH hosts. To make simple setups more
          convenient the name of an attribute in this set is used as a host name
          for the entry. This behaviour can be disabled by setting
          `hostNames` explicitly. You can use
          `extraHostNames` to add additional host names without
          disabling this default.
        '';
        example = literalExpression ''
          {
            myhost = {
              extraHostNames = [ "myhost.mydomain.com" "10.10.1.4" ];
              publicKeyFile = ./pubkeys/myhost_ssh_host_dsa_key.pub;
            };
            "myhost2.net".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILIRuJ8p1Fi+m6WkHV0KWnRfpM1WxoW8XAS+XvsSKsTK";
            "myhost2.net/dsa" = {
              hostNames = [ "myhost2.net" ];
              publicKeyFile = ./pubkeys/myhost2_ssh_host_dsa_key.pub;
            };
          }
        '';
      };

      knownHostsFiles = mkOption {
        default = [];
        type = with types; listOf path;
        description = lib.mdDoc ''
          Files containing SSH host keys to set as global known hosts.
          `/etc/ssh/ssh_known_hosts` (which is
          generated by {option}`programs.ssh.knownHosts`) and
          `/etc/ssh/ssh_known_hosts2` are always
          included.
        '';
        example = literalExpression ''
          [
            ./known_hosts
            (writeText "github.keys" '''
              github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
              github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
              github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
            ''')
          ]
        '';
      };

      kexAlgorithms = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = [ "curve25519-sha256@libssh.org" "diffie-hellman-group-exchange-sha256" ];
        description = lib.mdDoc ''
          Specifies the available KEX (Key Exchange) algorithms.
        '';
      };

      ciphers = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = [ "chacha20-poly1305@openssh.com" "aes256-gcm@openssh.com" ];
        description = lib.mdDoc ''
          Specifies the ciphers allowed and their order of preference.
        '';
      };

      macs = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = [ "hmac-sha2-512-etm@openssh.com" "hmac-sha1" ];
        description = lib.mdDoc ''
          Specifies the MAC (message authentication code) algorithms in order of preference. The MAC algorithm is used
          for data integrity protection.
        '';
      };
    };

  };

  config = {

    programs.ssh.setXAuthLocation =
      mkDefault (config.services.xserver.enable || config.programs.ssh.forwardX11 || config.services.openssh.settings.X11Forwarding);

    assertions =
      [ { assertion = cfg.forwardX11 -> cfg.setXAuthLocation;
          message = "cannot enable X11 forwarding without setting XAuth location";
        }
      ] ++ flip mapAttrsToList cfg.knownHosts (name: data: {
        assertion = (data.publicKey == null && data.publicKeyFile != null) ||
                    (data.publicKey != null && data.publicKeyFile == null);
        message = "knownHost ${name} must contain either a publicKey or publicKeyFile";
      });

    # SSH configuration. Slight duplication of the sshd_config
    # generation in the sshd service.
    environment.etc."ssh/ssh_config".text =
      ''
        # Custom options from `extraConfig`, to override generated options
        ${cfg.extraConfig}

        # Generated options from other settings
        Host *
        AddressFamily ${if config.networking.enableIPv6 then "any" else "inet"}
        GlobalKnownHostsFile ${concatStringsSep " " knownHostsFiles}

        ${optionalString cfg.setXAuthLocation ''
          XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
        ''}

        ForwardX11 ${if cfg.forwardX11 then "yes" else "no"}

        ${optionalString (cfg.pubkeyAcceptedKeyTypes != []) "PubkeyAcceptedKeyTypes ${concatStringsSep "," cfg.pubkeyAcceptedKeyTypes}"}
        ${optionalString (cfg.hostKeyAlgorithms != []) "HostKeyAlgorithms ${concatStringsSep "," cfg.hostKeyAlgorithms}"}
        ${optionalString (cfg.kexAlgorithms != null) "KexAlgorithms ${concatStringsSep "," cfg.kexAlgorithms}"}
        ${optionalString (cfg.ciphers != null) "Ciphers ${concatStringsSep "," cfg.ciphers}"}
        ${optionalString (cfg.macs != null) "MACs ${concatStringsSep "," cfg.macs}"}
      '';

    environment.etc."ssh/ssh_known_hosts".text = knownHostsText;

    # FIXME: this should really be socket-activated for über-awesomeness.
    systemd.user.services.ssh-agent = mkIf cfg.startAgent
      { description = "SSH Agent";
        wantedBy = [ "default.target" ];
        unitConfig.ConditionUser = "!@system";
        serviceConfig =
          { ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/ssh-agent";
            ExecStart =
                "${cfg.package}/bin/ssh-agent " +
                optionalString (cfg.agentTimeout != null) ("-t ${cfg.agentTimeout} ") +
                optionalString (cfg.agentPKCS11Whitelist != null) ("-P ${cfg.agentPKCS11Whitelist} ") +
                "-a %t/ssh-agent";
            StandardOutput = "null";
            Type = "forking";
            Restart = "on-failure";
            SuccessExitStatus = "0 2";
          };
        # Allow ssh-agent to ask for confirmation. This requires the
        # unit to know about the user's $DISPLAY (via ‘systemctl
        # import-environment’).
        environment.SSH_ASKPASS = optionalString cfg.enableAskPassword askPasswordWrapper;
        environment.DISPLAY = "fake"; # required to make ssh-agent start $SSH_ASKPASS
      };

    environment.extraInit = optionalString cfg.startAgent
      ''
        if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
        fi
      '';

    environment.variables.SSH_ASKPASS = optionalString cfg.enableAskPassword askPassword;

  };
}
