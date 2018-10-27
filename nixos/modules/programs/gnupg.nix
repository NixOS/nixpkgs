{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.gnupg;

  xserverCfg = config.services.xserver;

  defaultPinentryFlavour =
    if xserverCfg.desktopManager.gnome3.enable then
      "gnome3"
    else if xserverCfg.desktopManager.lxqt.enable
         || xserverCfg.desktopManager.plasma5.enable then
      "qt"
    else if xserverCfg.xserver.enable then
      "gtk2"
    else
      null;

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

    agent.pinentryFlavour = mkOption {
      type = types.nullOr (types.enum pkgs.pinentry.flavours);
      example = "gtk2";
      description = ''
        Which pinentry interface to use. If not null, the path to the
        pinentry binary will be passed to gpg-agent via commandline and
        thus overrides the pinentry option in gpg-agent.conf in the user's
        home directory.
      '';
    };

    dirmngr.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables GnuPG network certificate management daemon with socket-activation for every user session.
      '';
    };
  };

  config = mkIf cfg.agent.enable {
    programs.gnupg.agent.pinentryFlavour = mkDefault defaultPinentryFlavour;

    # This overrides the systemd user unit shipped with the gnupg package
    systemd.user.services.gpg-agent = mkIf (cfg.agent.pinentryFlavour != null) {
      serviceConfig.ExecStart = [ "" ''
        ${pkgs.gnupg}/bin/gpg-agent --supervised \
          --pinentry-program ${pkgs.pinentry.${cfg.agent.pinentryFlavour}}/bin/pinentry
      '' ];
    };

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
  };

}
