{ config, lib, pkgs, ... }:

let
  cfg = config.services.asusd;
in
{
  options = {
    services.asusd = {
      enable = lib.mkEnableOption (lib.mdDoc "the asusd service for ASUS ROG laptops");

      enableUserService = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          Activate the asusd-user service.
        '';
      };

      animeConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/asusd/anime.ron.
          See https://asus-linux.org/asusctl/#anime-control.
        '';
      };

      asusdConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/asusd/asusd.ron.
          See https://asus-linux.org/asusctl/.
        '';
      };

      auraConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/asusd/aura.ron.
          See https://asus-linux.org/asusctl/#led-keyboard-control.
        '';
      };

      profileConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/asusd/profile.ron.
          See https://asus-linux.org/asusctl/#profiles.
        '';
      };

      fanCurvesConfig = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = lib.mdDoc ''
          The content of /etc/asusd/fan_curves.ron.
          See https://asus-linux.org/asusctl/#fan-curves.
        '';
      };

      userLedModesConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/asusd/asusd-user-ledmodes.ron.
          See https://asus-linux.org/asusctl/#led-keyboard-control.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.asusctl ];

    environment.etc =
      let
        maybeConfig = name: cfg: lib.mkIf (cfg != null) {
          source = pkgs.writeText name cfg;
          mode = "0644";
        };
      in
      {
        "asusd/anime.ron" = maybeConfig "anime.ron" cfg.animeConfig;
        "asusd/asusd.ron" = maybeConfig "asusd.ron" cfg.asusdConfig;
        "asusd/aura.ron" = maybeConfig "aura.ron" cfg.auraConfig;
        "asusd/profile.conf" = maybeConfig "profile.ron" cfg.profileConfig;
        "asusd/fan_curves.ron" = maybeConfig "fan_curves.ron" cfg.fanCurvesConfig;
        "asusd/asusd_user_ledmodes.ron" = maybeConfig "asusd_user_ledmodes.ron" cfg.userLedModesConfig;
      };

    services.dbus.enable = true;
    systemd.packages = [ pkgs.asusctl ];
    services.dbus.packages = [ pkgs.asusctl ];
    services.udev.packages = [ pkgs.asusctl ];
    services.supergfxd.enable = lib.mkDefault true;

    systemd.user.services.asusd-user.enable = cfg.enableUserService;
  };

  meta.maintainers = pkgs.asusctl.meta.maintainers;
}
