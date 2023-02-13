{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.clight;

  toConf = v:
    if builtins.isFloat v then toString v
    else if isInt v       then toString v
    else if isBool v      then boolToString v
    else if isString v    then ''"${escape [''"''] v}"''
    else if isList v      then "[ " + concatMapStringsSep ", " toConf v + " ]"
    else if isAttrs v     then "\n{\n" + convertAttrs v + "\n}"
    else abort "clight.toConf: unexpected type (v = ${v})";

  getSep = v:
    if isAttrs v then ":"
    else "=";

  convertAttrs = attrs: concatStringsSep "\n" (mapAttrsToList
    (name: value: "${toString name} ${getSep value} ${toConf value};")
    attrs);

  clightConf = pkgs.writeText "clight.conf" (convertAttrs
    (filterAttrs
      (_: value: value != null)
      cfg.settings));
in {
  options.services.clight = {
    enable = mkEnableOption (lib.mdDoc "clight");

    temperature = {
      day = mkOption {
        type = types.int;
        default = 5500;
        description = lib.mdDoc ''
          Colour temperature to use during the day, between
          `1000` and `25000` K.
        '';
      };
      night = mkOption {
        type = types.int;
        default = 3700;
        description = lib.mdDoc ''
          Colour temperature to use at night, between
          `1000` and `25000` K.
        '';
      };
    };

    settings = let
      validConfigTypes = with types; oneOf [ int str bool float ];
      collectionTypes = with types; oneOf [ validConfigTypes (listOf validConfigTypes) ];
    in mkOption {
      type = with types; attrsOf (nullOr (either collectionTypes (attrsOf collectionTypes)));
      default = {};
      example = { captures = 20; gamma_long_transition = true; ac_capture_timeouts = [ 120 300 60 ]; };
      description = lib.mdDoc ''
        Additional configuration to extend clight.conf. See
        <https://github.com/FedeDP/Clight/blob/master/Extra/clight.conf> for a
        sample configuration file.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = let
      inRange = v: l: r: v >= l && v <= r;
    in [
      { assertion = config.location.provider == "manual" ->
          inRange config.location.latitude (-90) 90 && inRange config.location.longitude (-180) 180;
        message = "You must specify a valid latitude and longitude if manually providing location"; }
    ];

    boot.kernelModules = [ "i2c_dev" ];
    environment.systemPackages = with pkgs; [ clight clightd ];
    services.dbus.packages = with pkgs; [ clight clightd ];
    services.upower.enable = true;

    services.clight.settings = {
      gamma.temp = with cfg.temperature; mkDefault [ day night ];
    } // (optionalAttrs (config.location.provider == "manual") {
      daytime.latitude = mkDefault config.location.latitude;
      daytime.longitude = mkDefault config.location.longitude;
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
      after = [ "upower.service" "clightd.service" ];
      wants = [ "upower.service" "clightd.service" ];
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
