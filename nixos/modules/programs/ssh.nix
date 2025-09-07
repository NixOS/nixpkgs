# Global configuration for the SSH client.

{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.ssh;

  askPasswordWrapper = pkgs.writeScript "ssh-askpass-wrapper" ''
    #! ${pkgs.runtimeShell} -e
    eval export $(systemctl --user show-environment | ${lib.getExe pkgs.gnugrep} -E '^(DISPLAY|WAYLAND_DISPLAY|XAUTHORITY)=')
    exec ${cfg.askPassword} "$@"
  '';

  knownHosts = builtins.attrValues cfg.knownHosts;

  knownHostsText =
    (lib.flip (lib.concatMapStringsSep "\n") knownHosts (
      h:
      assert h.hostNames != [ ];
      lib.optionalString h.certAuthority "@cert-authority "
      + builtins.concatStringsSep "," h.hostNames
      + " "
      + (if h.publicKey != null then h.publicKey else builtins.readFile h.publicKeyFile)
    ))
    + "\n";

  knownHostsFiles = [
    "/etc/ssh/ssh_known_hosts"
  ]
  ++ builtins.map pkgs.copyPathToStore cfg.knownHostsFiles;

in
{
  ###### interface

  options = {

    programs.ssh = {

      enableAskPassword = lib.mkOption {
        type = lib.types.bool;
        default = config.services.xserver.enable;
        defaultText = lib.literalExpression "config.services.xserver.enable";
        description = "Whether to configure SSH_ASKPASS in the environment.";
      };

      systemd-ssh-proxy.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable systemd's ssh proxy plugin.
          See {manpage}`systemd-ssh-proxy(1)`.
        '';
      };

      askPassword = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
        defaultText = lib.literalExpression ''"''${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass"'';
        description = "Program used by SSH to ask for passwords.";
      };

      forwardX11 = lib.mkOption {
        type = with lib.types; nullOr bool;
        default = false;
        description = ''
          Whether to request X11 forwarding on outgoing connections by default.
          If set to null, the option is not set at all.
          This is useful for running graphical programs on the remote machine and have them display to your local X11 server.
          Historically, this value has depended on the value used by the local sshd daemon, but there really isn't a relation between the two.
          Note: there are some security risks to forwarding an X11 connection.
          NixOS's X server is built with the SECURITY extension, which prevents some obvious attacks.
          To enable or disable forwarding on a per-connection basis, see the -X and -x options to ssh.
          The -Y option to ssh enables trusted forwarding, which bypasses the SECURITY extension.
        '';
      };

      setXAuthLocation = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to set the path to {command}`xauth` for X11-forwarded connections.
          This causes a dependency on X11 packages.
        '';
      };

      pubkeyAcceptedKeyTypes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "ssh-ed25519"
          "ssh-rsa"
        ];
        description = ''
          Specifies the key lib.types that will be used for public key authentication.
        '';
      };

      hostKeyAlgorithms = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "ssh-ed25519"
          "ssh-rsa"
        ];
        description = ''
          Specifies the host key algorithms that the client wants to use in order of preference.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration text prepended to {file}`ssh_config`. Other generated
          options will be added after a `Host *` pattern.
          See {manpage}`ssh_config(5)`
          for help.
        '';
      };

      startAgent = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to start the OpenSSH agent when you log in.  The OpenSSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          {command}`ssh-add` to add a key to the agent.
        '';
      };

      agentTimeout = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "1h";
        description = ''
          How long to keep the private keys in memory. Use null to keep them forever.
        '';
      };

      agentPKCS11Whitelist = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = lib.literalExpression ''"''${pkgs.opensc}/lib/opensc-pkcs11.so"'';
        description = ''
          A pattern-list of acceptable paths for PKCS#11 shared libraries
          that may be used with the -s option to ssh-add.
        '';
      };

      package = lib.mkPackageOption pkgs "openssh" { };

      knownHosts = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule (
            {
              name,
              config,
              options,
              ...
            }:
            {
              options = {
                certAuthority = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = ''
                    This public key is an SSH certificate authority, rather than an
                    individual host's key.
                  '';
                };
                hostNames = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ name ] ++ config.extraHostNames;
                  defaultText = lib.literalExpression "[ ${name} ] ++ config.${options.extraHostNames}";
                  description = ''
                    A list of host names and/or IP numbers used for accessing
                    the host's ssh service. This list includes the name of the
                    containing `knownHosts` attribute by default
                    for convenience. If you wish to configure multiple host keys
                    for the same host use multiple `knownHosts`
                    entries with different attribute names and the same
                    `hostNames` list.
                  '';
                };
                extraHostNames = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = ''
                    A list of additional host names and/or IP numbers used for
                    accessing the host's ssh service. This list is ignored if
                    `hostNames` is set explicitly.
                  '';
                };
                publicKey = lib.mkOption {
                  default = null;
                  type = lib.types.nullOr lib.types.str;
                  example = "ecdsa-sha2-nistp521 AAAAE2VjZHN...UEPg==";
                  description = ''
                    The public key data for the host. You can fetch a public key
                    from a running SSH server with the {command}`ssh-keyscan`
                    command. The public key should not include any host names, only
                    the key type and the key itself.
                  '';
                };
                publicKeyFile = lib.mkOption {
                  default = null;
                  type = lib.types.nullOr lib.types.path;
                  description = ''
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
            }
          )
        );
        description = ''
          The set of system-wide known SSH hosts. To make simple setups more
          convenient the name of an attribute in this set is used as a host name
          for the entry. This behaviour can be disabled by setting
          `hostNames` explicitly. You can use
          `extraHostNames` to add additional host names without
          disabling this default.
        '';
        example = lib.literalExpression ''
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

      knownHostsFiles = lib.mkOption {
        default = [ ];
        type = with lib.types; listOf path;
        description = ''
          Files containing SSH host keys to set as global known hosts.
          `/etc/ssh/ssh_known_hosts` (which is
          generated by {option}`programs.ssh.knownHosts`) is
          always included.
        '';
        example = lib.literalExpression ''
          [
            ./known_hosts
            (writeText "github.keys" '''
              github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
              github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
              github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
            ''')
          ]
        '';
      };

      kexAlgorithms = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        example = [
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];
        description = ''
          Specifies the available KEX (Key Exchange) algorithms.
        '';
      };

      ciphers = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        example = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
        ];
        description = ''
          Specifies the ciphers allowed and their order of preference.
        '';
      };

      macs = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        example = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha1"
        ];
        description = ''
          Specifies the MAC (message authentication code) algorithms in order of preference. The MAC algorithm is used
          for data integrity protection.
        '';
      };
    };

  };

  config = {

    programs.ssh.setXAuthLocation = lib.mkDefault (
      config.services.xserver.enable
      || config.programs.ssh.forwardX11 == true
      || config.services.openssh.settings.X11Forwarding
    );

    assertions = [
      {
        assertion = cfg.forwardX11 == true -> cfg.setXAuthLocation;
        message = "cannot enable X11 forwarding without setting XAuth location";
      }
    ]
    ++ lib.flip lib.mapAttrsToList cfg.knownHosts (
      name: data: {
        assertion =
          (data.publicKey == null && data.publicKeyFile != null)
          || (data.publicKey != null && data.publicKeyFile == null);
        message = "knownHost ${name} must contain either a publicKey or publicKeyFile";
      }
    );

    environment.corePackages = [ cfg.package ];

    # SSH configuration. Slight duplication of the sshd_config
    # generation in the sshd service.
    environment.etc."ssh/ssh_config".text = ''
      # Custom options from `extraConfig`, to override generated options
      ${cfg.extraConfig}

      # Generated options from other settings
      Host *
      ${lib.optionalString cfg.systemd-ssh-proxy.enable ''
        # See systemd-ssh-proxy(1)
        Include ${config.systemd.package}/lib/systemd/ssh_config.d/20-systemd-ssh-proxy.conf
      ''}

      GlobalKnownHostsFile ${builtins.concatStringsSep " " knownHostsFiles}

      ${lib.optionalString (!config.networking.enableIPv6) "AddressFamily inet"}
      ${lib.optionalString cfg.setXAuthLocation "XAuthLocation ${pkgs.xorg.xauth}/bin/xauth"}
      ${lib.optionalString (cfg.forwardX11 != null)
        "ForwardX11 ${if cfg.forwardX11 then "yes" else "no"}"
      }

      ${lib.optionalString (
        cfg.pubkeyAcceptedKeyTypes != [ ]
      ) "PubkeyAcceptedKeyTypes ${builtins.concatStringsSep "," cfg.pubkeyAcceptedKeyTypes}"}
      ${lib.optionalString (
        cfg.hostKeyAlgorithms != [ ]
      ) "HostKeyAlgorithms ${builtins.concatStringsSep "," cfg.hostKeyAlgorithms}"}
      ${lib.optionalString (
        cfg.kexAlgorithms != null
      ) "KexAlgorithms ${builtins.concatStringsSep "," cfg.kexAlgorithms}"}
      ${lib.optionalString (cfg.ciphers != null) "Ciphers ${builtins.concatStringsSep "," cfg.ciphers}"}
      ${lib.optionalString (cfg.macs != null) "MACs ${builtins.concatStringsSep "," cfg.macs}"}
    '';

    environment.etc."ssh/ssh_known_hosts".text = knownHostsText;

    # FIXME: this should really be socket-activated for über-awesomeness.
    systemd.user.services.ssh-agent = lib.mkIf cfg.startAgent {
      description = "SSH Agent";
      wantedBy = [ "default.target" ];
      unitConfig.ConditionUser = "!@system";
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/ssh-agent";
        ExecStart =
          "${cfg.package}/bin/ssh-agent "
          + lib.optionalString (cfg.agentTimeout != null) ("-t ${cfg.agentTimeout} ")
          + lib.optionalString (cfg.agentPKCS11Whitelist != null) ("-P ${cfg.agentPKCS11Whitelist} ")
          + "-a %t/ssh-agent";
        StandardOutput = "null";
        Type = "forking";
        Restart = "on-failure";
        SuccessExitStatus = "0 2";
      };
      # Allow ssh-agent to ask for confirmation. This requires the
      # unit to know about the user's $DISPLAY (via ‘systemctl
      # import-environment’).
      environment.SSH_ASKPASS = lib.optionalString cfg.enableAskPassword askPasswordWrapper;
      environment.DISPLAY = "fake"; # required to make ssh-agent start $SSH_ASKPASS
    };

    environment.extraInit = lib.optionalString cfg.startAgent ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
      fi
    '';

    environment.variables.SSH_ASKPASS = lib.optionalString cfg.enableAskPassword cfg.askPassword;

  };
}
