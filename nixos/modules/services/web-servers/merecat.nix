{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.merecat;
  format = pkgs.formats.keyValue {
    mkKeyValue = generators.mkKeyValueDefault {
      mkValueString =
        v:
        # In merecat.conf, booleans are "true" and "false"
        if builtins.isBool v then if v then "true" else "false" else generators.mkValueStringDefault { } v;
    } "=";
  };
  configFile = format.generate "merecat.conf" cfg.settings;

in
{

  options.services.merecat = {

    enable = mkEnableOption "Merecat HTTP server";

    settings = mkOption {
      inherit (format) type;
      default = { };
      description = ''
        Merecat configuration. Refer to {manpage}`merecat(8)` for details on supported values.
      '';
      example = {
        hostname = "localhost";
        port = 8080;
        virtual-host = true;
        directory = "/srv/www";
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.services.merecat = {
      description = "Merecat HTTP server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.merecat}/bin/merecat -n -f ${configFile}";
        AmbientCapabilities = lib.mkIf ((cfg.settings.port or 80) < 1024) [ "CAP_NET_BIND_SERVICE" ];
      };
    };

  };

}
