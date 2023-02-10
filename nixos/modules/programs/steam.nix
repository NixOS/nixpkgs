{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.steam;
in {
  options.programs.steam = {
    enable = mkEnableOption (lib.mdDoc "steam");

    package = mkOption {
      type        = types.package;
      default     = pkgs.steam.override {
        extraLibraries = pkgs: with config.hardware.opengl;
          if pkgs.stdenv.hostPlatform.is64bit
          then [ package ] ++ extraPackages
          else [ package32 ] ++ extraPackages32;
      };
      defaultText = literalExpression ''
        pkgs.steam.override {
          extraLibraries = pkgs: with config.hardware.opengl;
            if pkgs.stdenv.hostPlatform.is64bit
            then [ package ] ++ extraPackages
            else [ package32 ] ++ extraPackages32;
        }
      '';
      description = lib.mdDoc ''
        steam package to use.
      '';
    };

    remotePlay.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open ports in the firewall for Steam Remote Play.
      '';
    };

    dedicatedServer.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open ports in the firewall for Source Dedicated Server.
      '';
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl = { # this fixes the "glXChooseVisual failed" bug, context: https://github.com/NixOS/nixpkgs/issues/47932
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # optionally enable 32bit pulseaudio support if pulseaudio is enabled
    hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

    hardware.steam-hardware.enable = true;

    environment.systemPackages = [
      cfg.package
      cfg.package.run
    ];

    networking.firewall = lib.mkMerge [
      (mkIf cfg.remotePlay.openFirewall {
        allowedTCPPorts = [ 27036 ];
        allowedUDPPortRanges = [ { from = 27031; to = 27036; } ];
      })

      (mkIf cfg.dedicatedServer.openFirewall {
        allowedTCPPorts = [ 27015 ]; # SRCDS Rcon port
        allowedUDPPorts = [ 27015 ]; # Gameplay traffic
      })
    ];
  };

  meta.maintainers = with maintainers; [ mkg20001 ];
}
