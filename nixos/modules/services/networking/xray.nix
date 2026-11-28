{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  validFormats = [
    "json"
    "yaml"
    "yml"
    "toml"
  ];
  extraSettingFileSubmodule = types.submodule (
    { config, ... }: {
      options = {
        path = mkOption {
          type = types.path;
          description = ''
            The absolute path to the configuration file.

            xray selects the parser from the file extension, so files ending in
            `.json`, `.yaml`, `.yml` or `.toml` are read as JSON, YAML or TOML
            respectively. When the file comes from a secret manager, make sure
            the secret's path keeps the extension or explicitly specify
            extension using `format`.

            xray prepends `outbounds` elements to the beginning unless filename
            contains `tail`. When the file comes from a secret manager, make
            sure the secret's path keeps the filename or explicitly specify
            behavior using `tail`.

            See <https://xtls.github.io/en/config/features/multiple.html>.
          '';
        };
        tail = mkOption {
          type = types.bool;
          defaultText = literalMD "Auto-detected based on the `path` filename.";
          default = hasInfix "tail" (toLower (baseNameOf config.path));

          description = ''
            Whether outbounds rules must be appended to the end.

            xray prepends `outbounds` elements to the beginning unless filename
            contains `tail`.

            See <https://xtls.github.io/en/config/features/multiple.html>.
          '';
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
          description = ''
            The format of the configuration file.

            xray selects the parser from the file extension, so files ending in
            `.json`, `.yaml`, `.yml` or `.toml` are read as JSON, YAML or TOML
            respectively. When the file comes from a secret manager, make sure
            the secret's path keeps the extension or explicitly specify
            extension using `format`.

            See <https://xtls.github.io/en/config/features/multiple.html>.
          '';
        };
      };
    }
  );
in
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

          xray selects the parser from the file extension, so files ending in
          `.json`, `.yaml`, `.yml` or `.toml` are read as JSON, YAML or TOML
          respectively. The fallback is JSON. When the file comes from a
          secret manager, make sure the secret's path keeps the extension.

          Either `settingsFile` or `settings` must be specified.

          See <https://xtls.github.io/en/config/>.
        '';
      };

      extraSettingFiles = mkOption {
        type = types.listOf (
          types.coercedTo (types.either types.str types.path) (path: {
            inherit path;
          }) extraSettingFileSubmodule
        );
        default = [ ];
        example = [
          "/run/xray-secrets/vless-inbounds-1.json"
          "/run/xray-secrets/vless-inbounds-2-tail.yml"
          {
            path = "/run/xray-secrets/append-outbound-to-the-end.json";
            tail = true;
          }
          {
            path = "/run/xray-secrets/file-with-incorrect.extension";
            format = "json";
          }
        ];

        description = ''
          Additional settings files used to configure xray. Later files update
          or override previous settings.

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

          See <https://xtls.github.io/en/config/>.
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
          findFirst (
            ext: hasSuffix ".${ext}" (toString cfg.settingsFile)
          ) (warn "Invalid file extension for Xray config file" "json") validFormats;

      allSettingsFiles = [
        {
          path = settingsFile;
          credentialFile = "config.${settingsExtension}";
        }
      ]
      ++ (imap0 (index: item: {
        inherit (item) path;
        # prefixes only matter if configs are passed via `-confdir`
        credentialFile = "config-extra-${toString index}${optionalString item.tail "-tail"}.${item.format}";
      }) cfg.extraSettingFiles);
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
