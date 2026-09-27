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
        example = "/etc/xray/config.json";
        description = ''
          The absolute path to the configuration file.

          Either `settingsFile` or `settings` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };

      extraSettingsFiles =
        let
          validFormats = [
            "json"
            "jsonc"
            "yaml"
            "yml"
            "toml"
            "pb"
            "protobuf"
          ];
          extraSettingFileSubmodule = types.submodule (
            { config, ... }: {
              options = {
                path = mkOption {
                  type = types.path;
                  description = "The absolute path to the configuration file.";
                };
                tail = mkOption {
                  type = types.bool;
                  default = false;
                  description = "Whether outbounds rules must be appended to the end.";
                };
                format = mkOption {
                  type = types.enum validFormats;
                  defaultText = literalMD "Auto-detected based on the `path` extension.";
                  default =
                    let
                      extension = last (splitString "." config.path);
                    in
                    if elem extension validFormats then
                      extension
                    else
                      throw "Couldn't auto-detect format for ${config.path}, please specify `format` explicitly.";
                  description = "The format of the configuration file.";
                };
              };
            }
          );
          extraSettingFileType = types.coercedTo types.str (path: {
            inherit path;
          }) extraSettingFileSubmodule;
        in
        mkOption {
          type = types.listOf extraSettingFileType;
          default = [ ];
          example = [
            "/run/xray-secrets/vless-inbounds-1.json"
            "/run/xray-secrets/vless-inbounds-2.yml"
            {
              path = "/run/xray-secrets/append-outbound-to-the-end.json";
              tail = true;
            }
            {
              path = "/run/xray-secrets/file-with-incorrect.extension";
              format = "json";
            }
          ];
          # https://www.v2fly.org/en_US/config/multiple_config.html lacks English translation
          description = ''
            Additional settings files used to configure xray. Later files update or override previous settings.

            See <https://xtls.github.io/en/config/features/multiple.html>.
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
      allSettingsFiles = [
        {
          path = settingsFile;
          credentialFile = "config.json";
        }
      ]
      ++ (lib.imap0 (index: item: {
        inherit (item) path;
        # prefixes only matter if configs are passed via `-confdir`
        credentialFile = "config-extra-${toString index}${lib.optionalString item.tail "-tail"}.${item.format}";
      }) cfg.extraSettingsFiles);
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
          ExecStart = lib.concatStringsSep " " (
            [
              "${cfg.package}/bin/xray"
            ]
            ++ (map (x: "-config \"\${CREDENTIALS_DIRECTORY}\"/${x.credentialFile}") allSettingsFiles)
          );
          DynamicUser = true;
          LoadCredential = map (x: "${x.credentialFile}:${x.path}") allSettingsFiles;
          CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          NoNewPrivileges = true;
        };
      };
    };
}
