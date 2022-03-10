{ config, lib, pkgs, ... }:

let
  cfg = config.services.pipewire.wireplumber;
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
    systemd.packages = [ cfg.package ];

    systemd.services.wireplumber.enable = config.services.pipewire.systemWide;
    systemd.user.services.wireplumber.enable = !config.services.pipewire.systemWide;

    systemd.services.wireplumber.wantedBy = [ "pipewire.service" ];
    systemd.user.services.wireplumber.wantedBy = [ "pipewire.service" ];
  };
}
