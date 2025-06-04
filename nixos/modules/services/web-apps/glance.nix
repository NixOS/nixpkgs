{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.glance;

  inherit (lib)
    catAttrs
    concatMapStrings
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  inherit (builtins)
    concatLists
    isAttrs
    isList
    attrNames
    getAttr
    ;

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "glance.yaml" cfg.settings;
  mergedSettingsFile = "/run/glance/glance.yaml";
in
{
  options.services.glance = {
    enable = mkEnableOption "glance";
    package = mkPackageOption pkgs "glance" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          server = {
            host = mkOption {
              description = "Glance bind address";
              default = "127.0.0.1";
              example = "0.0.0.0";
              type = types.str;
            };
            port = mkOption {
              description = "Glance port to listen on";
              default = 8080;
              example = 5678;
              type = types.port;
            };
          };
          pages = mkOption {
            type = settingsFormat.type;
            description = ''
              List of pages to be present on the dashboard.

              See <https://github.com/glanceapp/glance/blob/main/docs/configuration.md#pages--columns>
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
                          _secret = "/var/lib/secrets/glance/location";
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
        Configuration written to a yaml file that is read by glance. See
        <https://github.com/glanceapp/glance/blob/main/docs/configuration.md>
        for more.

        Settings containing secret data should be set to an
        attribute set containing the attribute
        <literal>_secret</literal> - a string pointing to a file
        containing the value the option should be set to. See the
        example in `services.glance.settings.pages` at the weather widget
        with a location secret to get a better picture of this.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for Glance.
        This adds `services.glance.settings.server.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.glance = {
      description = "Glance feed dashboard server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.replace-secret ];

      serviceConfig = {
        ExecStartPre =
          let
            findSecrets =
              data:
              if isAttrs data then
                if data ? _secret then
                  [ data ]
                else
                  concatLists (map (attr: findSecrets (getAttr attr data)) (attrNames data))
              else if isList data then
                concatLists (map findSecrets data)
              else
                [ ];
            secretPaths = catAttrs "_secret" (findSecrets cfg.settings);
            mkSecretReplacement = secretPath: ''
              replace-secret ${
                lib.escapeShellArgs [
                  "_secret: ${secretPath}"
                  secretPath
                  mergedSettingsFile
                ]
              }
            '';
            secretReplacements = concatMapStrings mkSecretReplacement secretPaths;
          in
          # Use "+" to run as root because the secrets may not be accessible to glance
          "+"
          + pkgs.writeShellScript "glance-start-pre" ''
            install -m 600 -o $USER ${settingsFile} ${mergedSettingsFile}
            ${secretReplacements}
          '';
        ExecStart = "${getExe cfg.package} --config ${mergedSettingsFile}";
        WorkingDirectory = "/var/lib/glance";
        StateDirectory = "glance";
        RuntimeDirectory = "glance";
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

  meta.doc = ./glance.md;
  meta.maintainers = [ lib.maintainers.drupol ];
}
