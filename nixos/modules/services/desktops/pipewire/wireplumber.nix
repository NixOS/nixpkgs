{ config, lib, pkgs, ... }:

let
  pwCfg = config.services.pipewire;
  cfg = pwCfg.wireplumber;
  pwUsedForAudio = pwCfg.audio.enable;
in
{
  meta.maintainers = [ lib.maintainers.k900 ];

  options = {
    services.pipewire.wireplumber = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.services.pipewire.enable;
        defaultText = lib.literalExpression "config.services.pipewire.enable";
        description = "Whether to enable Wireplumber, a modular session / policy manager for PipeWire";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.wireplumber;
        defaultText = lib.literalExpression "pkgs.wireplumber";
        description = "The wireplumber derivation to use.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.pipewire.media-session.enable;
        message = "WirePlumber and pipewire-media-session can't be enabled at the same time.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    environment.etc."wireplumber/main.lua.d/80-nixos.lua" = lib.mkIf (!pwUsedForAudio) {
     text = ''
        -- Pipewire is not used for audio, so prevent it from grabbing audio devices
        alsa_monitor.enable = function() end
      '';
    };

    systemd.packages = [ cfg.package ];

    systemd.services.wireplumber.enable = config.services.pipewire.systemWide;
    systemd.user.services.wireplumber.enable = !config.services.pipewire.systemWide;

    systemd.services.wireplumber.wantedBy = [ "pipewire.service" ];
    systemd.user.services.wireplumber.wantedBy = [ "pipewire.service" ];
  };
}
