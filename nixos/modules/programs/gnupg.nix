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
      default = false;
      description = ''
        Enable SSH agent support in GnuPG agent. Also sets SSH_AUTH_SOCK
        environment variable correctly. This will disable socket-activation
        and thus always start a GnuPG agent per user session.
      '';
    };

    agent.enableExtraSocket = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable extra socket for GnuPG agent.
      '';
    };

    agent.enableBrowserSocket = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable browser socket for GnuPG agent.
      '';
    };

    dirmngr.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables GnuPG network certificate management daemon with socket-activation for every user session.
      '';
    };

    trezor-agent.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the Trezor GnuPG agent service, which allows you to use your
        Trezor as a GnuPG agent for signing and decrypting.
      '';
    };

    trezor-agent.configPath = mkOption {
      type = types.string;
      default = "/var/empty";
      example = "/home/alice/.gnupg/trezor";
      description = ''
        The GNUPGHOME path for your Trezor GnuPG config. See
        https://github.com/romanz/trezor-agent/blob/master/README-GPG.md on how
        to set this up.
      '';
    };

  };

  config = mkIf cfg.agent.enable {
    systemd.user.sockets.gpg-agent = {
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.gpg-agent-ssh = mkIf cfg.agent.enableSSHSupport {
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.gpg-agent-extra = mkIf cfg.agent.enableExtraSocket {
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.gpg-agent-browser = mkIf cfg.agent.enableBrowserSocket {
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.dirmngr = mkIf cfg.dirmngr.enable {
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
      { assertion = cfg.agent.enableSSHSupport -> !config.programs.ssh.startAgent;
        message = "You can't use ssh-agent and GnuPG agent with SSH support enabled at the same time!";
      }
    ];
  } // (mkIf cfg.trezor-agent.enable  {
    systemd.user.services.trezor-agent = {
      description = "Trezor GnuPG Agent";

      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.gnupg ];

      environment = {
        GNUPGHOME=cfg.trezor-agent.configPath;
      };

      serviceConfig.ExecStart = "${pkgs.python27Packages.trezor_agent}/bin/trezor-gpg-agent";
    };
  });

}
