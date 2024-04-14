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
    mkDefault
    mkIf
    mkOption
    types
    ;

  cfg = config.nix;

in
{
  options = {
    nix = {
      channel = {
        enable = mkOption {
          description = ''
            Whether the `nix-channel` command and state files are made available on the machine.

            The following files are initialized when enabled:
              - `/nix/var/nix/profiles/per-user/root/channels`
              - `/root/.nix-channels`
              - `$HOME/.nix-defexpr/channels` (on login)

            Disabling this option will not remove the state files from the system.
          '';
          type = types.bool;
          default = true;
        };
      };

      nixPath = mkOption {
        type = types.listOf types.str;
        default =
          if cfg.channel.enable
          then [
            "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
            "nixos-config=/etc/nixos/configuration.nix"
            "/nix/var/nix/profiles/per-user/root/channels"
          ]
          else [ ];
        defaultText = ''
          if nix.channel.enable
          then [
            "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
            "nixos-config=/etc/nixos/configuration.nix"
            "/nix/var/nix/profiles/per-user/root/channels"
          ]
          else [];
        '';
        description = ''
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
        description = "Default NixOS channel to which the root user is subscribed.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.extraInit =
      mkIf cfg.channel.enable ''
        if [ -e "$HOME/.nix-defexpr/channels" ]; then
          export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}"
        fi
      '';

    environment.extraSetup = mkIf (!cfg.channel.enable) ''
      rm --force $out/bin/nix-channel
    '';

    # NIX_PATH has a non-empty default according to Nix docs, so we don't unset
    # it when empty.
    environment.sessionVariables = {
      NIX_PATH = cfg.nixPath;
    };

    nix.settings.nix-path = mkIf (! cfg.channel.enable) (mkDefault "");

    systemd.tmpfiles.rules = lib.mkIf cfg.channel.enable [
      ''f /root/.nix-channels - - - - ${config.system.defaultChannel} nixos\n''
    ];
  };
}
