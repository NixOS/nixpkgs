{ config, lib, pkgs, ... }:

let
  cfg = config.services.asusd;
  json = pkgs.formats.json { };
  toml = pkgs.formats.toml { };
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
        type = json.type;
        default = { };
        description = lib.mdDoc ''
          The content of /etc/asusd/anime.conf.
          See https://asus-linux.org/asusctl/#anime-control.
        '';
      };

      asusdConfig = lib.mkOption {
        type = json.type;
        default = { };
        description = lib.mdDoc ''
          The content of /etc/asusd/asusd.conf.
          See https://asus-linux.org/asusctl/.
        '';
      };

      auraConfig = lib.mkOption {
        type = json.type;
        default = { };
        description = lib.mdDoc ''
          The content of /etc/asusd/aura.conf.
          See https://asus-linux.org/asusctl/#led-keyboard-control.
        '';
      };

      profileConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "";
        description = lib.mdDoc ''
          The content of /etc/asusd/profile.conf.
          See https://asus-linux.org/asusctl/#profiles.
        '';
      };

      ledModesConfig = lib.mkOption {
        type = lib.types.nullOr toml.type;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/asusd/asusd-ledmodes.toml. Leave `null` to use default settings.
          See https://asus-linux.org/asusctl/#led-keyboard-control.
        '';
      };

      userLedModesConfig = lib.mkOption {
        type = lib.types.nullOr toml.type;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/asusd/asusd-user-ledmodes.toml.
          See https://asus-linux.org/asusctl/#led-keyboard-control.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.asusctl ];

    environment.etc =
      let
        maybeConfig = name: cfg: lib.mkIf (cfg != { }) {
          source = json.generate name cfg;
          mode = "0644";
        };
      in
      {
        "asusd/anime.conf" = maybeConfig "anime.conf" cfg.animeConfig;
        "asusd/asusd.conf" = maybeConfig "asusd.conf" cfg.asusdConfig;
        "asusd/aura.conf" = maybeConfig "aura.conf" cfg.auraConfig;
        "asusd/profile.conf" = lib.mkIf (cfg.profileConfig != null) {
          source = pkgs.writeText "profile.conf" cfg.profileConfig;
          mode = "0644";
        };
        "asusd/asusd-ledmodes.toml" = {
          source =
            if cfg.ledModesConfig == null
            then "${pkgs.asusctl}/share/asusd/data/asusd-ledmodes.toml"
            else toml.generate "asusd-ledmodes.toml" cfg.ledModesConfig;
          mode = "0644";
        };
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
