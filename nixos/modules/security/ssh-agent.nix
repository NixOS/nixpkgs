{ config, pkgs, lib, ... }:
let
  cfg = config.security.SSHAgent;
in {

  options = {
    security.SSHAgent = {
      socket = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The path to the SSH agent socket";
      };
    };
  };


  config = lib.mkIf cfg.socket != null {
    environment.extraInit =   ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK=${cfg.socket}
      fi
    '';
  };


}