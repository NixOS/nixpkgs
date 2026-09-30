{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.dynacat;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = "/run/dynacat/dynacat.yml";
in
{
  options.services.dynacat = {
    enable = mkEnableOption "Dynacat, a self-hosted dashboard";
    package = mkPackageOption pkgs "dynacat" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          server = {
            host = mkOption {
              description = "Dynacat bind address";
              default = "127.0.0.1";
              example = "0.0.0.0";
              type = types.str;
            };
            port = mkOption {
              description = "Dynacat port to listen on";
              default = 8080;
              example = 5678;
              type = types.port;
            };
            assets-path = mkOption {
              description = ''
                Directory served under `/assets/`, for self-hosted icons and
                custom CSS. Upstream's default only exists inside its container
                image.
              '';
              default = "/var/lib/dynacat/assets";
              type = types.str;
            };
            cache-dir = mkOption {
              description = "Directory where Dynacat caches remote images";
              default = "/var/cache/dynacat";
              type = types.str;
            };
            db-path = mkOption {
              description = ''
                SQLite database used by `to-do` widgets with `storage: server`.
              '';
              default = "/var/lib/dynacat/dynacat.db";
              type = types.str;
            };
            allow-editing = mkOption {
              description = ''
                Whether the web UI editor may change the configuration.

                The configuration file is regenerated from
                {option}`services.dynacat.settings` every time the service
                starts, so changes made in the editor are lost on the next
                restart. Enable this to lay out pages in the editor and copy
                the result back into {option}`services.dynacat.settings`.

                Upstream enables the editor by default; this module does not,
                because without an `auth` section anyone who can reach Dynacat
                could rewrite its configuration.
              '';
              default = false;
              example = true;
              type = types.bool;
            };
          };
          pages = mkOption {
            type = settingsFormat.type;
            description = ''
              List of pages to be present on the dashboard.

              See <https://github.com/Panonim/dynacat/blob/main/docs/docs/configuration.md#pages--columns>
            '';
            default = [
              {
                name = "Calendar";
                columns = [
                  {
                    size = "full";
                    widgets = [ { type = "calendar"; } ];
                  }
                ];
              }
            ];
            example = [
              {
                name = "Home";
                columns = [
                  {
                    size = "full";
                    widgets = [
                      { type = "calendar"; }
                      {
                        type = "weather";
                        location = {
                          _secret = "/var/lib/secrets/dynacat/location";
                        };
                      }
                    ];
                  }
                ];
              }
            ];
          };
        };
      };
      default = { };
      description = ''
        Configuration written to a yaml file that is read by Dynacat. See
        <https://github.com/Panonim/dynacat/blob/main/docs/docs/configuration.md>
        for more.

        Settings containing secret data should be set to an
        attribute set with this format: `{ _secret = "/path/to/secret"; }`.
        See the example in `services.dynacat.settings.pages` at the weather widget
        with a location secret to get a better picture of this.

        Alternatively, you can use a single file with environment variables,
        see `services.dynacat.environmentFile`.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      description =
        let
          singleQuotes = "''";
        in
        ''
          Path to an environment file as defined in {manpage}`systemd.exec(5)`.

          See upstream documentation
          <https://github.com/Panonim/dynacat/blob/main/docs/docs/configuration.md#environment-variables>.

          Example content of the file:
          ```
          TIMEZONE=Europe/Paris
          ```

          Example `services.dynacat.settings.pages` configuration:
          ```nix
            [
              {
                name = "Home";
                columns = [
                  {
                    size = "full";
                    widgets = [
                      {
                        type = "clock";
                        timezone = "\''${TIMEZONE}";
                        label = "Local Time";
                      }
                    ];
                  }
                ];
              }
            ];
          ```

          Note that when using Dynacat's `''${ENV_VAR}` syntax in Nix,
          you need to escape it as follows: use `\''${ENV_VAR}` in `"` strings
          and `${singleQuotes}''${ENV_VAR}` in `${singleQuotes}` strings.

          Alternatively, you can put each secret in it's own file,
          see `services.dynacat.settings`.
        '';
      default = null;
      example = "/var/lib/secrets/dynacat";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for Dynacat.
        This adds `services.dynacat.settings.server.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.dynacat = {
      description = "Dynacat dashboard server";
      wantedBy = [ "multi-user.target" ];
      # OIDC discovery and remote widgets need the network as soon as Dynacat starts.
      wants = [ "network-online.target" ];
      # adding nss-user-lookup.target is a fix for https://github.com/NixOS/nixpkgs/issues/409348
      after = [
        "network-online.target"
        "nss-user-lookup.target"
      ];
      requires = [
        "nss-user-lookup.target"
      ];

      serviceConfig = {
        ExecStartPre =
          # Use "+" to run as root because the secrets may not be accessible to dynacat
          "+"
          + pkgs.writeShellScript "dynacat-start-pre" ''
            ${utils.genJqSecretsReplacementSnippet cfg.settings settingsFile}
            chown $USER ${settingsFile}
          '';
        ExecStart = "${getExe cfg.package} --config ${settingsFile}";
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/dynacat";
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = [
          "dynacat"
          "dynacat/assets"
        ];
        CacheDirectory = "dynacat";
        RuntimeDirectory = "dynacat";
        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        DynamicUser = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProcSubset = "all";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.server.port ]; };
  };

  meta.maintainers = with lib.maintainers; [
    andreszb
  ];
}
