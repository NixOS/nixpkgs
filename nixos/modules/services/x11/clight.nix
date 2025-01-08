{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.clight;

  toConf =
    v:
    if builtins.isFloat v then
      toString v
    else if lib.isInt v then
      toString v
    else if lib.isBool v then
      lib.boolToString v
    else if lib.isString v then
      ''"${lib.escape [ ''"'' ] v}"''
    else if lib.isList v then
      "[ " + lib.concatMapStringsSep ", " toConf v + " ]"
    else if lib.isAttrs v then
      "\n{\n" + convertAttrs v + "\n}"
    else
      abort "clight.toConf: unexpected type (v = ${v})";

  getSep = v: if lib.isAttrs v then ":" else "=";

  convertAttrs =
    attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "${toString name} ${getSep value} ${toConf value};") attrs
    );

  clightConf = pkgs.writeText "clight.conf" (
    convertAttrs (lib.filterAttrs (_: value: value != null) cfg.settings)
  );
in
{
  options.services.clight = {
    enable = lib.mkEnableOption "clight";

    temperature = {
      day = lib.mkOption {
        type = lib.types.int;
        default = 5500;
        description = ''
          Colour temperature to use during the day, between
          `1000` and `25000` K.
        '';
      };
      night = lib.mkOption {
        type = lib.types.int;
        default = 3700;
        description = ''
          Colour temperature to use at night, between
          `1000` and `25000` K.
        '';
      };
    };

    settings =
      let
        validConfigTypes =
          with lib.types;
          oneOf [
            int
            str
            bool
            float
          ];
        collectionTypes =
          with lib.types;
          oneOf [
            validConfigTypes
            (listOf validConfigTypes)
          ];
      in
      lib.mkOption {
        type = with lib.types; attrsOf (nullOr (either collectionTypes (attrsOf collectionTypes)));
        default = { };
        example = {
          captures = 20;
          gamma_long_transition = true;
          ac_capture_timeouts = [
            120
            300
            60
          ];
        };
        description = ''
          Additional configuration to extend clight.conf. See
          <https://github.com/FedeDP/Clight/blob/master/Extra/clight.conf> for a
          sample configuration file.
        '';
      };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      let
        inRange =
          v: l: r:
          v >= l && v <= r;
      in
      [
        {
          assertion =
            config.location.provider == "manual"
            -> inRange config.location.latitude (-90) 90 && inRange config.location.longitude (-180) 180;
          message = "You must specify a valid latitude and longitude if manually providing location";
        }
      ];

    boot.kernelModules = [ "i2c_dev" ];
    environment.systemPackages = with pkgs; [
      clight
      clightd
    ];
    services.dbus.packages = with pkgs; [
      clight
      clightd
    ];
    services.upower.enable = true;

    services.clight.settings =
      {
        gamma.temp =
          with cfg.temperature;
          mkDefault [
            day
            night
          ];
      }
      // (lib.optionalAttrs (config.location.provider == "manual") {
        daytime.latitude = lib.mkDefault config.location.latitude;
        daytime.longitude = lib.mkDefault config.location.longitude;
      });

    services.geoclue2.appConfig.clightc = {
      isAllowed = true;
      isSystem = true;
    };

    systemd.services.clightd = {
      requires = [ "polkit.service" ];
      wantedBy = [ "multi-user.target" ];

      description = "Bus service to manage various screen related properties (gamma, dpms, backlight)";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.clightd.clightd";
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = ''
          ${pkgs.clightd}/bin/clightd
        '';
      };
    };

    systemd.user.services.clight = {
      after = [
        "upower.service"
        "clightd.service"
      ];
      wants = [
        "upower.service"
        "clightd.service"
      ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      description = "C daemon to adjust screen brightness to match ambient brightness, as computed capturing frames from webcam";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = ''
          ${pkgs.clight}/bin/clight --conf-file ${clightConf}
        '';
      };
    };
  };
}
