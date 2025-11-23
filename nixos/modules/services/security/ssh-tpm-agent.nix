{
  config,
  lib,
  pkgs,
  ...
}:
{
  meta.maintainers = with lib.maintainers; [ arunoruto ];

  options.services.ssh-tpm-agent = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Start the SSH TPM agent on login.
      '';
    };

    package = lib.mkPackageOption pkgs "ssh-tpm-agent" { };

    hostSocket = lib.mkOption {
      type = lib.types.str;
      default = "/var/tmp/ssh-tpm-agent.sock";
      description = ''
        Location of the ssh-tpm-agent socket.
      '';
    };

    userProxyPath = lib.mkOption {
      type = lib.types.str;
      default = if config.services.gnome.gnome-keyring.enable then "keyring/ssh" else "";
      description = "Path relative to the runtime root (`$XDG_RUNTIME_DIR`) to be proxied to";
    };
  };

  config =
    let
      cfg = config.services.ssh-tpm-agent;
      proxy-set = lib.stringLength cfg.userProxyPath > 0;
    in
    lib.mkIf cfg.enable {
      security.tpm2 = {
        enable = lib.mkDefault true;
        pkcs11.enable = lib.mkDefault true;
      };

      environment = {
        systemPackages = [ cfg.package ];
        # Set variable for POSIX complient shells
        extraInit = lib.optionalString proxy-set ''
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-tpm-agent.sock"
        '';
      };

      systemd = {
        packages = [ cfg.package ];

        # System services
        services = {
          ssh-tpm-genkeys = rec {
            description = "SSH TPM Key Generation";
            unitConfig = {
              Description = description;
              ConditionPathExists = [
                "|!/etc/ssh/ssh_tpm_host_ecdsa_key.tpm"
                "|!/etc/ssh/ssh_tpm_host_ecdsa_key.pub"
                "|!/etc/ssh/ssh_tpm_host_rsa_key.tpm"
                "|!/etc/ssh/ssh_tpm_host_rsa_key.pub"
              ];
            };
            serviceConfig = {
              Type = "oneshot";
              ExecStart = ''${cfg.package}/bin/ssh-tpm-keygen -A'';
              RemainAfterExit = "yes";
            };
          };

          ssh-tpm-agent = {
            unitConfig = {
              ConditionEnvironment = "!SSH_AGENT_PID";
              Description = "ssh-tpm-agent service";
              Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
              Wants = "ssh-tpm-genkeys.service";
              After = [
                "ssh-tpm-genkeys.service"
                "network.target"
                "sshd.target"
              ];
              Requires = "ssh-tpm-agent.socket";
            };

            serviceConfig = {
              ExecStart = "${cfg.package}/bin/ssh-tpm-agent -d -l ${cfg.hostSocket} --key-dir /etc/ssh";
              PassEnvironment = "SSH_AGENT_PID";
              KillMode = "process";
              Restart = "always";
            };

            wantedBy = [ "multi-user.target" ];
          };
        };
        sockets = {
          ssh-tpm-agent = {
            unitConfig = {
              Description = "SSH TPM agent socket";
              Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
            };

            socketConfig = {
              ListenStream = cfg.hostSocket;
              SocketMode = "0600";
              Service = "ssh-tpm-agent.service";
            };

            wantedBy = [ "sockets.target" ];
          };
        };

        # User services
        user = {
          services.ssh-tpm-agent = {
            unitConfig = {
              ConditionEnvironment = "!SSH_AGENT_PID";
              Description = "ssh-tpm-agent service";
              Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
              Requires = "ssh-tpm-agent.socket";
            };

            serviceConfig = {
              Environment = "SSH_AUTH_SOCK=%t/ssh-tpm-agent.sock";
              ExecStart =
                "${cfg.package}/bin/ssh-tpm-agent -d" + lib.optionalString proxy-set " -A %t/${cfg.userProxyPath}";
              PassEnvironment = "SSH_AGENT_PID";
              SuccessExitStatus = "2";
              Type = "simple";
            };

            wantedBy = [ "default.target" ];
          };

          sockets.ssh-tpm-agent = {
            unitConfig = {
              Description = "SSH TPM agent socket";
              Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
            };

            socketConfig = {
              ListenStream = "%t/ssh-tpm-agent.sock";
              SocketMode = "0600";
              Service = "ssh-tpm-agent.service";
            };

            wantedBy = [ "sockets.target" ];
          };
        };
      };

      services.openssh.extraConfig = ''
        HostKeyAgent ${cfg.hostSocket}
        HostKey /etc/ssh/ssh_tpm_host_ecdsa_key.pub
        HostKey /etc/ssh/ssh_tpm_host_rsa_key.pub
      '';
    };
}
