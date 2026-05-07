{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ssh-agent-switcher;
in
{
  meta.maintainers = [ lib.maintainers.jmmv ];

  options = {
    services.ssh-agent-switcher = {
      enable = lib.mkEnableOption "ssh-agent-switcher daemon" // {
        description = ''
          Whether to enable ssh-agent-switcher, a daemon that proxies SSH agent
          connections to forwarded agents. This allows tmux/screen sessions to
          access SSH agents across reconnections.

          This is a per-user service that automatically starts when you log in
          via SSH and sets SSH_AUTH_SOCK to point to a stable socket location.

          Note: This only activates for SSH sessions, not graphical or console logins.
        '';
      };

      package = lib.mkPackageOption pkgs "ssh-agent-switcher" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.loginShellInit = ''
      if [ -n "$SSH_CONNECTION" ]; then
        mkdir -p "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
        export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent-switcher.sock"
        ${lib.getExe cfg.package} --daemon --socket-path="$SSH_AUTH_SOCK" 2>/dev/null || true
      fi
    '';
  };
}
