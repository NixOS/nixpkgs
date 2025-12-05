{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options = {

    services.xray = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run xray server.

          Either `settingsFile` or `settings` must be specified.
        '';
      };

      package = mkPackageOption pkgs "xray" { };

      settingsExtension = mkOption {
        type = types.enum [
          "json"
          "yaml"
          "toml"
        ];
        default = "json";
        description = ''
          Configuration file extension for xray. JSON, YAML and TOML are supported.

          Note: If `settingsFile` is used, its extension must match the configured extension, otherwise xray will fail to parse it.
        '';
      };

      settingsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/xray/config.json";
        description = ''
          The absolute path to the configuration file.

          Either `settingsFile` or `settings` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };

      settings = mkOption {
        type = types.nullOr (types.attrsOf types.unspecified);
        default = null;
        example = {
          inbounds = [
            {
              port = 1080;
              listen = "127.0.0.1";
              protocol = "http";
            }
          ];
          outbounds = [
            {
              protocol = "freedom";
            }
          ];
        };
        description = ''
          The configuration object.

          Either `settingsFile` or `settings` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };
    };

  };

  config =
    let
      cfg = config.services.xray;
      extension = cfg.settingsExtension;
      serializer = (pkgs.formats.${extension} { }).generate "xray.${extension}";

      settingsFile = if cfg.settingsFile != null then cfg.settingsFile else serializer cfg.settings;

    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = (cfg.settingsFile == null) != (cfg.settings == null);
          message = "Either but not both `settingsFile` and `settings` should be specified for xray.";
        }
      ];

      systemd.services.xray = {
        description = "xray Daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          exec "${cfg.package}/bin/xray" -config "$CREDENTIALS_DIRECTORY/config.${extension}"
        '';
        serviceConfig = {
          DynamicUser = true;
          LoadCredential = "config.${extension}:${settingsFile}";
          CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          NoNewPrivileges = true;
        };
      };
    };
}
