{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    stringAfter
    types
    ;

  cfg = config.nix;

in
{
  options = {
    system = {
      defaultChannel = mkOption {
        internal = true;
        type = types.str;
        default = "https://nixos.org/channels/nixos-unstable";
        description = lib.mdDoc "Default NixOS channel to which the root user is subscribed.";
      };
    };
  };

  config = mkIf cfg.enable {

    system.activationScripts.nix-channel = stringAfter [ "etc" "users" ]
      ''
        # Subscribe the root user to the NixOS channel by default.
        if [ ! -e "/root/.nix-channels" ]; then
            echo "${config.system.defaultChannel} nixos" > "/root/.nix-channels"
        fi
      '';
  };
}
