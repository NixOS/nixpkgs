{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.gnome.gcr-ssh-agent;
in
{
  meta = {
    maintainers = lib.teams.gnome.members;
  };

  options = {
    services.gnome.gcr-ssh-agent = {
      enable = lib.mkEnableOption "GCR ssh-agent";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ pkgs.gcr_4 ];

    # Set SSH_AUTH_SOCK in session environment since not all DEs/display managers will use environment variables from systemd
    environment.extraInit = ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
      fi
    '';
  };
}
