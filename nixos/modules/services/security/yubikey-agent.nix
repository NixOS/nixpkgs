# Global configuration for yubikey-agent.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.yubikey-agent;

  # reuse the pinentryFlavor option from the gnupg module
  pinentryFlavor = config.programs.gnupg.agent.pinentryFlavor;
in
{
  ###### interface

  meta.maintainers = with maintainers; [ philandstuff rawkode jwoudenberg ];

  options = {

    services.yubikey-agent = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to start yubikey-agent when you log in.  Also sets
          SSH_AUTH_SOCK to point at yubikey-agent.

          Note that yubikey-agent will use whatever pinentry is
          specified in programs.gnupg.agent.pinentryFlavor.
        '';
      };

      package = mkPackageOption pkgs "yubikey-agent" { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    # This overrides the systemd user unit shipped with the
    # yubikey-agent package
    systemd.user.services.yubikey-agent = mkIf (pinentryFlavor != null) {
      path = [ pkgs.pinentry.${pinentryFlavor} ];
      wantedBy = [
        (if pinentryFlavor == "tty" || pinentryFlavor == "curses" then
          "default.target"
        else
          "graphical-session.target")
      ];
    };

    # Yubikey-agent expects pcsd to be running in order to function.
    services.pcscd.enable = true;

    environment.extraInit = ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
      fi
    '';
  };
}
