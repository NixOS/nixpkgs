{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cross-seed;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.cross-seed = {
    enable = mkEnableOption "cross-seed";

    package = mkPackageOption pkgs "cross-seed" { };

    user = mkOption {
      type = types.str;
      default = "cross-seed";
      description = "User to run cross-seed as.";
    };

    group = mkOption {
      type = types.str;
      default = "cross-seed";
      example = "torrents";
      description = "Group to run cross-seed as.";
    };

    configDir = mkOption {
      type = types.path;
      default = "/var/lib/cross-seed";
      description = "Cross-seed config directory";
    };

    settings = mkOption {
      default = { };
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          dataDirs = mkOption {
            type = types.listOf types.path;
            default = [ ];
            description = ''
              Paths to be searched for matching data.

              If you use Injection, cross-seed will use the specified linkType
              to create a link to the original file in the linkDirs.

              If linkType is hardlink, these must be on the same volume as the
              data.
            '';
          };

          linkDirs = mkOption {
            type = types.listOf types.path;
            default = [ ];
            description = ''
              List of directories where cross-seed will create links.

              If linkType is hardlink, these must be on the same volume as the data.
            '';
          };

          torrentDir = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              Directory containing torrent files, or if you're using a torrent
              client integration and injection - your torrent client's .torrent
              file store/cache.
            '';
          };

          outputDir = mkOption {
            type = types.path;
            default = "${cfg.configDir}/output";
            defaultText = ''''${cfg.configDir}/output'';
            description = "Directory where cross-seed will place torrent files it finds.";
          };

          port = mkOption {
            type = types.port;
            default = 2468;
            example = 3000;
            description = "Port the cross-seed daemon listens on.";
          };
        };
      };

      description = ''
        Configuration options for cross-seed.

        Secrets should not be set in this option, as they will be available in
        the Nix store. For secrets, please use settingsFile.

        For more details, see [the cross-seed documentation](https://www.cross-seed.org/docs/basics/options).
      '';
    };

    settingsFile = lib.mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Path to a JSON file containing settings that will be merged with the
        settings option. This is suitable for storing secrets, as they will not
        be exposed on the Nix store.
      '';
    };
  };

  config =
    let
      jsonSettingsFile = settingsFormat.generate "settings.json" cfg.settings;

      # Since cross-seed uses a javascript config file, we can use node's
      # ability to parse JSON directly to avoid having to do any conversion.
      # This also means we don't need to use any external programs to merge the
      # secrets.
      secretSettingsSegment =
        lib.optionalString (cfg.settingsFile != null) # js
          ''
            const path = require("node:path");
            const secret_settings_json = path.join(process.env.CREDENTIALS_DIRECTORY, "secretSettingsFile");
            Object.assign(loaded_settings, JSON.parse(fs.readFileSync(secret_settings_json, "utf8")));
          '';

      javascriptConfig =
        pkgs.writeText "config.js" # js
          ''
            "use strict";
            const fs = require("fs");
            const settings_json = "${jsonSettingsFile}";
            let loaded_settings = JSON.parse(fs.readFileSync(settings_json, "utf8"));
            ${secretSettingsSegment}
            module.exports = loaded_settings;
          '';
    in
    lib.mkIf (cfg.enable) {
      assertions = [
        {
          assertion = !(cfg.settings ? apiKey);
          message = ''
            The API key should be set via the settingsFile option, to avoid
            exposing it on the Nix store.
          '';
        }
      ];

      systemd.tmpfiles.settings."10-cross-seed" = {
        ${cfg.configDir}.d = {
          inherit (cfg) group user;
          mode = "700";
        };

        ${cfg.settings.outputDir}.d = {
          inherit (cfg) group user;
          mode = "750";
        };
      };

      systemd.services.cross-seed = {
        description = "cross-seed";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        environment.CONFIG_DIR = cfg.configDir;
        preStart = ''
          install -D -m 600 -o '${cfg.user}' -g '${cfg.group}' '${javascriptConfig}' '${cfg.configDir}/config.js'
        '';

        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} daemon";
          User = cfg.user;
          Group = cfg.group;

          # Only allow binding to the specified port.
          SocketBindDeny = "any";
          SocketBindAllow = cfg.settings.port;

          LoadCredential = lib.mkIf (cfg.settingsFile != null) "secretSettingsFile:${cfg.settingsFile}";

          StateDirectory = "cross-seed";
          ReadWritePaths = [ cfg.settings.outputDir ];
          ReadOnlyPaths = lib.optional (cfg.settings.torrentDir != null) cfg.settings.torrentDir;
        };

        unitConfig = {
          # Unfortunately, we can not protect these if we are to hardlink between them, as they need to be on the same volume for hardlinks to work.
          RequiresMountsFor = lib.flatten [
            cfg.settings.dataDirs
            cfg.settings.linkDirs
            cfg.settings.outputDir
          ];
        };
      };

      # It's useful to have the package in the path, to be able to e.g. get the API key.
      environment.systemPackages = [ cfg.package ];

      users.users = lib.mkIf (cfg.user == "cross-seed") {
        cross-seed = {
          group = cfg.group;
          description = "cross-seed user";
          isSystemUser = true;
          home = cfg.configDir;
        };
      };

      users.groups = lib.mkIf (cfg.group == "cross-seed") {
        cross-seed = { };
      };
    };
}
