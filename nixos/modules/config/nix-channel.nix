/*
  Manages the things that are needed for a traditional nix-channel based
  configuration to work.

  See also
   - ./nix.nix
   - ./nix-flakes.nix
 */
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
    nix = {
      nixPath = mkOption {
        type = types.listOf types.str;
        default = [
          "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
          "nixos-config=/etc/nixos/configuration.nix"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
        description = lib.mdDoc ''
          The default Nix expression search path, used by the Nix
          evaluator to look up paths enclosed in angle brackets
          (e.g. `<nixpkgs>`).
        '';
      };
    };

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

    environment.extraInit =
      ''
        if [ -e "$HOME/.nix-defexpr/channels" ]; then
          export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}"
        fi
      '';

    environment.sessionVariables = {
      NIX_PATH = cfg.nixPath;
    };

    system.activationScripts.nix-channel = stringAfter [ "etc" "users" ]
      ''
        # Subscribe the root user to the NixOS channel by default.
        if [ ! -e "/root/.nix-channels" ]; then
            echo "${config.system.defaultChannel} nixos" > "/root/.nix-channels"
        fi
      '';
  };
}
