{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.gnupg;

in

{

  options.programs.gnupg = {
    agent.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables GnuPG agent with socket-activation for every user session.
      '';
    };

    agent.enableSSHSupport = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable SSH agent support in GnuPG agent. Also sets SSH_AUTH_SOCK
        environment variable correctly. This will disable socket-activation
        and thus always start a GnuPG agent per user session.
      '';
    };
  };

  config = mkIf cfg.agent.enable {
    systemd.user.services.gpg-agent = {
      serviceConfig = {
        ExecStart = [
          ""
          ("${pkgs.gnupg}/bin/gpg-agent --supervised "
            + optionalString cfg.agent.enableSSHSupport "--enable-ssh-support")
        ];
      };
    };

    systemd.user.sockets.gpg-agent = {
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.gpg-agent-ssh = mkIf cfg.agent.enableSSHSupport {
      wantedBy = [ "sockets.target" ];
    };

    systemd.packages = [ pkgs.gnupg ];

    environment.extraInit = ''
      # Bind gpg-agent to this TTY if gpg commands are used.
      export GPG_TTY=$(tty)

    '' + (optionalString cfg.agent.enableSSHSupport ''
      # SSH agent protocol doesn't support changing TTYs, so bind the agent
      # to every new TTY.
      ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null

      if [ -z "$SSH_AUTH_SOCK" ]; then
        export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
      fi
    '');

    assertions = [
      { assertion = cfg.agent.enableSSHSupport && !config.programs.ssh.startAgent;
        message = "You can't use ssh-agent and GnuPG agent with SSH support enabled at the same time!";
      }
    ];
  };

}
