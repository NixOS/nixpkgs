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
      exec ${askPassword}
    '';

  knownHosts = map (h: getAttr h cfg.knownHosts) (attrNames cfg.knownHosts);

  knownHostsText = (flip (concatMapStringsSep "\n") knownHosts
    (h: assert h.hostNames != [];
      optionalString h.certAuthority "@cert-authority " + concatStringsSep "," h.hostNames + " "
      + (if h.publicKey != null then h.publicKey else readFile h.publicKeyFile)
    )) + "\n";

in
{
  ###### interface

  options = {

    programs.ssh = {

      askPassword = mkOption {
        type = types.str;
        default = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
        description = ''Program used by SSH to ask for passwords.'';
      };

      forwardX11 = mkOption {
        type = types.bool;
        default = false;
        description = ''
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
        description = ''
          Whether to set the path to <command>xauth</command> for X11-forwarded connections.
          This causes a dependency on X11 packages.
        '';
      };

      # Allow DSA keys for now. (These were deprecated in OpenSSH 7.0.)
      pubkeyAcceptedKeyTypes = mkOption {
        type = types.listOf types.str;
        default = [
          "+ssh-dss"
        ];
        example = [ "ssh-ed25519" "ssh-rsa" ];
        description = ''
          Specifies the key types that will be used for public key authentication.
        '';
      };

      hostKeyAlgorithms = mkOption {
        type = types.listOf types.str;
        default = [
          "+ssh-dss"
        ];
        example = [ "ssh-ed25519" "ssh-rsa" ];
        description = ''
          Specifies the host key algorithms that the client wants to use in order of preference.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration text prepended to <filename>ssh_config</filename>. Other generated
          options will be added after a <code>Host *</code> pattern.
          See <citerefentry><refentrytitle>ssh_config</refentrytitle><manvolnum>5</manvolnum></citerefentry>
          for help.
        '';
      };

      startAgent = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to start the OpenSSH agent when you log in.  The OpenSSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          <command>ssh-add</command> to add a key to the agent.
        '';
      };

      agentTimeout = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "1h";
        description = ''
          How long to keep the private keys in memory. Use null to keep them forever.
        '';
      };

      agentPKCS11Whitelist = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "\${pkgs.opensc}/lib/opensc-pkcs11.so";
        description = ''
          A pattern-list of acceptable paths for PKCS#11 shared libraries
          that may be used with the -s option to ssh-add.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.openssh;
        defaultText = "pkgs.openssh";
        description = ''
          The package used for the openssh client and daemon.
        '';
      };

      knownHosts = mkOption {
        default = {};
        type = types.loaOf (types.submodule ({ name, ... }: {
          options = {
            certAuthority = mkOption {
              type = types.bool;
              default = false;
              description = ''
                This public key is an SSH certificate authority, rather than an
                individual host's key.
              '';
            };
            hostNames = mkOption {
              type = types.listOf types.str;
              default = [];
              description = ''
                A list of host names and/or IP numbers used for accessing
                the host's ssh service.
              '';
            };
            publicKey = mkOption {
              default = null;
              type = types.nullOr types.str;
              example = "ecdsa-sha2-nistp521 AAAAE2VjZHN...UEPg==";
              description = ''
                The public key data for the host. You can fetch a public key
                from a running SSH server with the <command>ssh-keyscan</command>
                command. The public key should not include any host names, only
                the key type and the key itself.
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
          config = {
            hostNames = mkDefault [ name ];
          };
        }));
        description = ''
          The set of system-wide known SSH hosts.
        '';
        example = literalExample ''
          {
            myhost = {
              hostNames = [ "myhost" "myhost.mydomain.com" "10.10.1.4" ];
              publicKeyFile = ./pubkeys/myhost_ssh_host_dsa_key.pub;
            };
            myhost2 = {
              hostNames = [ "myhost2" ];
              publicKeyFile = ./pubkeys/myhost2_ssh_host_dsa_key.pub;
            };
          }
        '';
      };

    };

  };

  config = {

    programs.ssh.setXAuthLocation =
      mkDefault (config.services.xserver.enable || config.programs.ssh.forwardX11 || config.services.openssh.forwardX11);

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

        ${optionalString cfg.setXAuthLocation ''
          XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
        ''}

        ForwardX11 ${if cfg.forwardX11 then "yes" else "no"}

        ${optionalString (cfg.pubkeyAcceptedKeyTypes != []) "PubkeyAcceptedKeyTypes ${concatStringsSep "," cfg.pubkeyAcceptedKeyTypes}"}
        ${optionalString (cfg.hostKeyAlgorithms != []) "HostKeyAlgorithms ${concatStringsSep "," cfg.hostKeyAlgorithms}"}
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
        environment.SSH_ASKPASS = optionalString config.services.xserver.enable askPasswordWrapper;
        environment.DISPLAY = "fake"; # required to make ssh-agent start $SSH_ASKPASS
      };

    environment.extraInit = optionalString cfg.startAgent
      ''
        if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
        fi
      '';

    environment.variables.SSH_ASKPASS = optionalString config.services.xserver.enable askPassword;

  };
}
