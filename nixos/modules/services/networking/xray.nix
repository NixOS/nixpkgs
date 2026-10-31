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

      settingsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/xray/config.yaml";
        description = ''
          The absolute path to the configuration file.

          xray selects the parser from the file extension, so files ending in
          `.yaml`, `.yml` or `.toml` are read as YAML or TOML, and anything
          else is read as JSON. When the file comes from a secret manager, make
          sure the secret's path keeps the extension.

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
      settingsFile =
        if cfg.settingsFile != null then
          cfg.settingsFile
        else
          pkgs.writeTextFile {
            name = "xray.json";
            text = builtins.toJSON cfg.settings;
            checkPhase = ''
              ${cfg.package}/bin/xray -test -config $out
            '';
          };

      settingsExtension =
        if cfg.settingsFile == null then
          "json"
        else
          findFirst (ext: hasSuffix ".${ext}" (toString cfg.settingsFile)) "json" [
            "yaml"
            "yml"
            "toml"
          ];

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
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/xray -config \"\${CREDENTIALS_DIRECTORY}\"/config.${settingsExtension}";
          DynamicUser = true;
          LoadCredential = "config.${settingsExtension}:${settingsFile}";
          CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          NoNewPrivileges = true;
        };
      };
    };
}
