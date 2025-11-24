{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.tuliprox;
  settingsFormat = pkgs.formats.yaml { };
  systemSettingsYaml = settingsFormat.generate "config.yml" cfg.systemSettings;
  sourceSettingsYaml = settingsFormat.generate "source.yml" cfg.sourceSettings;
  apiProxySettingsYaml = settingsFormat.generate "api-proxy.yml" cfg.apiProxySettings;
  mappingSettingsYaml = settingsFormat.generate "mapping.yml" cfg.mappingSettings;
in
{
  meta.maintainers = with lib.maintainers; [ nyanloutre ];

  options.services.tuliprox = {
    enable = lib.mkEnableOption "Tuliprox IPTV playlist processor & proxy";

    package = lib.mkPackageOption pkgs "tuliprox" { };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional command-line arguments for the systemd service.

        Refer to the [Tuliprox documentation] for available arguments.

        [Tuliprox documentation]: https://github.com/euzu/tuliprox?tab=readme-ov-file#command-line-arguments
      '';
    };

    systemSettings = lib.mkOption {
      type = settingsFormat.type;
      example = {
        api = {
          host = "0.0.0.0";
          port = 8901;
        };
      };
      description = ''
        Main config file

        Refer to the [Tuliprox documentation] for available attributes

        [Tuliprox documentation]: https://github.com/euzu/tuliprox?tab=readme-ov-file#1-configyml
      '';
    };

    sourceSettings = lib.mkOption {
      type = settingsFormat.type;
      example = {
        templates = [
          {
            name = "not_red_button";
            value = "NOT (Title ~ \"(?i).*red button.*\")";
          }
          {
            name = "not_low_resolution";
            value = "NOT (Title ~ \"(?i).*\(360p|240p\).*\")";
          }
          {
            name = "all_channels";
            value = "Title ~ \".*\"";
          }
          {
            name = "final_channel_lineup";
            value = "!all_channels! AND !not_red_button! AND !not_low_resolution!";
          }
        ];
        sources = [
          {
            inputs = [
              {
                name = "iptv-org";
                type = "m3u";
                url = "https://iptv-org.github.io/iptv/countries/uk.m3u";
              }
            ];
            targets = [
              {
                name = "iptv-org";
                output = [
                  {
                    type = "xtream";
                  }
                  {
                    type = "m3u";
                    filename = "iptv.m3u";
                  }
                  {
                    type = "hdhomerun";
                    username = "local";
                    device = "hdhr1";
                  }
                ];
                filter = "!final_channel_lineup!";
                options = {
                  ignore_logo = false;
                  share_live_streams = true;
                };
                mapping = [
                  "iptv-org"
                ];
              }
            ];
          }
        ];
      };
      description = ''
        Source definitions

        Refer to the [Tuliprox documentation] for available attributes

        [Tuliprox documentation]: https://github.com/euzu/tuliprox?tab=readme-ov-file#2-sourceyml
      '';
    };

    apiProxySettings = lib.mkOption {
      type = settingsFormat.type;
      example = {
        server = [
          {
            name = "default";
            protocol = "http";
            host = "192.169.1.9";
            port = 8901;
            timezone = "Europe/Paris";
            message = "Welcome to tuliprox";
          }
          {
            name = "external";
            protocol = "https";
            host = "tuliprox.mydomain.tv";
            port = 443;
            timezone = "Europe/Paris";
            message = "Welcome to tuliprox";
          }
        ];
        user = [
          {
            target = "xc_m3u";
            credentials = [
              {
                username = "test1";
                password = "secret1";
                token = "token1";
                proxy = "reverse";
                server = "default";
                exp_date = 1672705545;
                max_connections = 1;
                status = "Active";
              }
            ];
          }
        ];
      };
      description = ''
        Users and proxy configuration

        Refer to the [Tuliprox documentation] for available attributes

        [Tuliprox documentation]: https://github.com/euzu/tuliprox?tab=readme-ov-file#3-api-proxy-config
      '';
    };

    mappingSettings = lib.mkOption {
      type = settingsFormat.type;
      example = {
        mappings = {
          templates = [
            {
              name = "bbc";
              value = "Title ~ \"^BBC\"";
            }
            {
              name = "documentary";
              value = "(Group ~ \"(Documentary|Outdoor)\")";
            }
            {
              name = "entertainment";
              value = "Group ~ \"Entertainment\"";
            }
            {
              name = "pluto_tv";
              value = "(Caption ~ \"Pluto TV\") AND NOT(Caption ~ \"Sports\")";
            }
            {
              name = "business";
              value = "Group ~ \"Business\"";
            }
          ];
          mapping = [
            {
              id = "iptv-org";
              match_as_ascii = true;
              mapper = [
                {
                  filter = "!bbc!";
                  script = ''
                    @Group = "BBC"
                  '';
                }
                {
                  filter = "!documentary!";
                  script = ''
                    @Group = "Documentary"
                  '';
                }
                {
                  filter = "!entertainment!";
                  script = ''
                    @Group = "Entertainment"
                  '';
                }
                {
                  filter = "!pluto_tv!";
                  script = ''
                    @Group = "Pluto TV"
                  '';
                }
                {
                  filter = "!business!";
                  script = ''
                    @Group = "News"
                  '';
                }
                {
                  filter = "Input ~ \"iptv-org\"";
                  script = ''
                    @Caption = concat(@Caption, " (iptv-org)")
                  '';
                }
              ];
            }
          ];
        };
      };
      description = ''
        Templates configuration

        Refer to the [Tuliprox documentation] for available attributes

        [Tuliprox documentation]: https://github.com/euzu/tuliprox?tab=readme-ov-file#2-mappingyml
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.tuliprox.systemSettings = {
      api = {
        host = lib.mkDefault "127.0.0.1";
        port = lib.mkDefault 8901;
        web_root = lib.mkDefault "${cfg.package}/web";
      };
      working_dir = lib.mkDefault "\${env:STATE_DIRECTORY}/data";
      backup_dir = lib.mkDefault "\${env:STATE_DIRECTORY}/backup";
      custom_stream_response_path = lib.mkDefault "${cfg.package}/resources";
    };
    services.tuliprox.sourceSettings.sources = lib.mkDefault [ ];
    services.tuliprox.apiProxySettings = {
      server = lib.mkDefault [
        {
          name = "default";
          protocol = "http";
          host = cfg.systemSettings.api.host;
          port = cfg.systemSettings.api.port;
          timezone = if config.time.timeZone != null then config.time.timeZone else "Etc/UTC";
          message = "Welcome to tuliprox";
        }
      ];
      user = lib.mkDefault [ ];
    };
    services.tuliprox.mappingSettings.mappings.mapping = lib.mkDefault [ ];

    systemd.services.tuliprox = {
      description = "Tuliprox server";

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "--server"
            "--config"
            systemSettingsYaml
            "--source"
            sourceSettingsYaml
            "--api-proxy"
            apiProxySettingsYaml
            "--mapping"
            mappingSettingsYaml
          ]
          ++ cfg.extraArgs
        );
        Restart = "always";

        DynamicUser = true;
        StateDirectory = "tuliprox";

        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0066";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
