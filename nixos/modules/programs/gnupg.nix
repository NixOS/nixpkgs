{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.gnupg;

  xserverCfg = config.services.xserver;

  defaultPinentryFlavor =
    if xserverCfg.desktopManager.lxqt.enable
    || xserverCfg.desktopManager.plasma5.enable then
      "qt"
    else if xserverCfg.desktopManager.xfce.enable then
      "gtk2"
    else if xserverCfg.enable || config.programs.sway.enable then
      "gnome3"
    else
      "curses";

in

{

  options.programs.gnupg = {
    package = mkOption {
      type = types.package;
      default = pkgs.gnupg;
      defaultText = literalExpression "pkgs.gnupg";
      description = lib.mdDoc ''
        The gpg package that should be used.
      '';
    };

    agent.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables GnuPG agent with socket-activation for every user session.
      '';
    };

    agent.enableSSHSupport = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable SSH agent support in GnuPG agent. Also sets SSH_AUTH_SOCK
        environment variable correctly. This will disable socket-activation
        and thus always start a GnuPG agent per user session.
      '';
    };

    agent.enableExtraSocket = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable extra socket for GnuPG agent.
      '';
    };

    agent.enableBrowserSocket = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable browser socket for GnuPG agent.
      '';
    };

    agent.pinentryFlavor = mkOption {
      type = types.nullOr (types.enum pkgs.pinentry.flavors);
      example = "gnome3";
      default = defaultPinentryFlavor;
      defaultText = literalMD ''matching the configured desktop environment'';
      description = lib.mdDoc ''
        Which pinentry interface to use. If not null, the path to the
        pinentry binary will be passed to gpg-agent via commandline and
        thus overrides the pinentry option in gpg-agent.conf in the user's
        home directory.
        If not set at all, it'll pick an appropriate flavor depending on the
        system configuration (qt flavor for lxqt and plasma5, gtk2 for xfce
        4.12, gnome3 on all other systems with X enabled, ncurses otherwise).
      '';
    };

    dirmngr.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables GnuPG network certificate management daemon with socket-activation for every user session.
      '';
    };
  };

  config = mkIf cfg.agent.enable {
    # This overrides the systemd user unit shipped with the gnupg package
    systemd.user.services.gpg-agent = mkIf (cfg.agent.pinentryFlavor != null) {
      serviceConfig.ExecStart = [ "" ''
        ${cfg.package}/bin/gpg-agent --supervised \
          --pinentry-program ${pkgs.pinentry.${cfg.agent.pinentryFlavor}}/bin/pinentry
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

    services.dbus.packages = mkIf (cfg.agent.pinentryFlavor == "gnome3") [ pkgs.gcr ];

    environment.systemPackages = with pkgs; [ cfg.package ];
    systemd.packages = [ cfg.package ];

    environment.interactiveShellInit = ''
      # Bind gpg-agent to this TTY if gpg commands are used.
      export GPG_TTY=$(tty)

    '' + (optionalString cfg.agent.enableSSHSupport ''
      # SSH agent protocol doesn't support changing TTYs, so bind the agent
      # to every new TTY.
      ${cfg.package}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
    '');

    environment.extraInit = mkIf cfg.agent.enableSSHSupport ''
      if [ -z "$SSH_AUTH_SOCK" ]; then
        export SSH_AUTH_SOCK=$(${cfg.package}/bin/gpgconf --list-dirs agent-ssh-socket)
      fi
    '';

    assertions = [
      { assertion = cfg.agent.enableSSHSupport -> !config.programs.ssh.startAgent;
        message = "You can't use ssh-agent and GnuPG agent with SSH support enabled at the same time!";
      }
    ];
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
