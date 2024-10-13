{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.asusd;
in
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "services"
        "asusd"
        "auraConfig"
      ]
      ''
        This option has been replaced by `services.asusd.auraConfigs' because asusd
        supports multiple aura devices since version 6.0.0.
      ''
    )
  ];

  options = {
    services.asusd = {
      enable = lib.mkEnableOption "the asusd service for ASUS ROG laptops";

      package = lib.mkPackageOption pkgs "asusctl" { };

      enableUserService = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Activate the asusd-user service.
        '';
      };

      animeConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The content of /etc/asusd/anime.ron.
          See https://asus-linux.org/asusctl/#anime-control.
        '';
      };

      asusdConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The content of /etc/asusd/asusd.ron.
          See https://asus-linux.org/asusctl/.
        '';
      };

      auraConfigs = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          The content of /etc/asusd/aura_<name>.ron.
          See https://asus-linux.org/asusctl/#led-keyboard-control.
        '';
      };

      profileConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The content of /etc/asusd/profile.ron.
          See https://asus-linux.org/asusctl/#profiles.
        '';
      };

      fanCurvesConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The content of /etc/asusd/fan_curves.ron.
          See https://asus-linux.org/asusctl/#fan-curves.
        '';
      };

      userLedModesConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The content of /etc/asusd/asusd-user-ledmodes.ron.
          See https://asus-linux.org/asusctl/#led-keyboard-control.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc =
      let
        maybeConfig =
          name: cfg:
          lib.mkIf (cfg != null) {
            source = pkgs.writeText name cfg;
            mode = "0644";
          };
      in
      {
        "asusd/anime.ron" = maybeConfig "anime.ron" cfg.animeConfig;
        "asusd/asusd.ron" = maybeConfig "asusd.ron" cfg.asusdConfig;
        "asusd/profile.ron" = maybeConfig "profile.ron" cfg.profileConfig;
        "asusd/fan_curves.ron" = maybeConfig "fan_curves.ron" cfg.fanCurvesConfig;
        "asusd/asusd_user_ledmodes.ron" = maybeConfig "asusd_user_ledmodes.ron" cfg.userLedModesConfig;
      }
      // lib.attrsets.concatMapAttrs (prod_id: value: {
        "asusd/aura_${prod_id}.ron" = maybeConfig "aura_${prod_id}.ron" value;
      }) cfg.auraConfigs;

    services.dbus.enable = true;
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
    services.supergfxd.enable = lib.mkDefault true;

    systemd.user.services.asusd-user.enable = cfg.enableUserService;
  };

  meta.maintainers = pkgs.asusctl.meta.maintainers;
}
