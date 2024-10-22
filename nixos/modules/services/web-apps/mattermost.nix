{ config, pkgs, lib, ... }:

let
  inherit (lib.strings)
    hasInfix hasSuffix escapeURL concatStringsSep escapeShellArgs;

  inherit (lib.attrsets)
    mapAttrsToList recursiveUpdate;

  inherit (lib.options)
    mkOption mkPackageOption mkEnableOption;

  inherit (lib.modules)
    mkRenamedOptionModule mkMerge mkIf;

  inherit (lib.trivial)
    warnIf throwIf;

  inherit (lib) types;

  cfg = config.services.mattermost;

  # The directory to store mutable data within dataDir.
  mutableDataDir = "${cfg.dataDir}/data";

  # The plugin directory. Note that this is the *post-unpack* plugin directory,
  # since Mattermost unpacks plugins to put them there. (Hence, mutable data.)
  pluginDir = "${mutableDataDir}/plugins";

  # Mattermost uses this as a staging directory to unpack plugins, among possibly other things.
  # Ensure that it's inside mutableDataDir since it can get rather large.
  tempDir = "${mutableDataDir}/tmp";

  mkDatabaseUri = {
    user ? null,
    password ? null,
    host ? null,
    port ? null,
    path ? null,
    query ? {}
  }: let
    nullToEmpty = val: if val == null then "" else toString val;

    # Converts a list of URI attrs to a query string.
    toQuery = mapAttrsToList (name: value:
      if value == null then null else (escapeURL name) + "=" + (escapeURL (toString value))
    );

    userPart =
      if user == null && password == null then
        ""
      else if user != null && password != null then
        escapeURL user + ":" + escapeURL password
      else
        escapeURL (if password != null then password else user);
    hostPart =
      if userPart == "" then
        escapeURL (nullToEmpty host)
      else
        "@" + escapeURL (nullToEmpty host);
    portPart =
      if port == null then ""
      else ":" + (toString port);
    pathPart =
      if path == null then ""
      else "/" + (escapeURL path);
    queryPart =
      if query == {} then ""
      else "?" + concatStringsSep "&" (toQuery query);
  in
    "postgres://" + userPart + hostPart + portPart + pathPart + queryPart;

  database =
    if cfg.database.peerAuth then
      mkDatabaseUri {
        path = cfg.database.name;
        query = { host = cfg.database.socketPath; } // cfg.database.extraConnectionOptions;
      }
    else
      mkDatabaseUri {
        inherit (cfg.database) user password host port;
        path = cfg.database.name;
        query = cfg.database.extraConnectionOptions;
      };

  mattermostPluginDerivations = with pkgs;
    map (plugin: stdenv.mkDerivation {
      name = "mattermost-plugin";
      installPhase = ''
        mkdir -p $out/share
        cp ${plugin} $out/share/plugin.tar.gz
      '';
      dontUnpack = true;
      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;
      preferLocalBuild = true;
    }) cfg.plugins;

  mattermostPlugins = with pkgs;
    if mattermostPluginDerivations == [] then null
    else stdenv.mkDerivation {
      name = "${cfg.package.name}-plugins";
      nativeBuildInputs = [
        autoPatchelfHook
      ] ++ mattermostPluginDerivations;
      buildInputs = [
        cfg.package
      ];
      installPhase = ''
        mkdir -p $out
        plugins=(${escapeShellArgs (map (plugin: "${plugin}/share/plugin.tar.gz") mattermostPluginDerivations)})
        for plugin in "''${plugins[@]}"; do
          hash="$(sha256sum "$plugin" | awk '{print $1}')"
          mkdir -p "$hash"
          tar -C "$hash" -xzf "$plugin"
          autoPatchelf "$hash"
          GZIP_OPT=-9 tar -C "$hash" -cvzf "$out/$hash.tar.gz" .
          rm -rf "$hash"
        done
      '';

      dontUnpack = true;
      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;
      preferLocalBuild = true;
    };

  mattermostConfWithoutPlugins = recursiveUpdate
    { ServiceSettings.SiteURL = cfg.siteUrl;
      ServiceSettings.ListenAddress = "${cfg.host}:${toString cfg.port}";
      TeamSettings.SiteName = cfg.siteName;
      SqlSettings.DriverName = "postgres";
      SqlSettings.DataSource =
        if cfg.database.fromEnvironment then
          null
        else
          warnIf (!cfg.database.peerAuth && cfg.database.password != null) ''
            Database password is set in Mattermost config! This password will end up in the Nix store.
            Write the following to ${if cfg.environmentFile == null then "your environment file" else cfg.environmentFile}:

            MM_SQLSETTINGS_DATASOURCE=${database}

            Then set the following options:
            services.mattermost.environmentFile = "<your environment file>";
            services.mattermost.database.fromEnvironment = true;

            Alternatively, you may be able to simply set the following, if the database is on the same host:
            services.mattermost.database.peerAuth = true;
          '' database;
      FileSettings.Directory = cfg.dataDir;
      PluginSettings.Directory = "${pluginDir}/server";
      PluginSettings.ClientDirectory = "${pluginDir}/client";
      LogSettings.FileLocation = cfg.logDir;
    }
    cfg.settings;

  mattermostConf = recursiveUpdate
    mattermostConfWithoutPlugins
    (
      if mattermostPlugins == null then {}
      else {
        PluginSettings = {
          Enable = true;
        };
      }
    );

  mattermostConfJSON = pkgs.writeText "mattermost-config.json" (builtins.toJSON mattermostConf);

in
{
  imports = [
    (mkRenamedOptionModule [ "services" "mattermost" "listenAddress" ] [ "services" "mattermost" "host" ])
    (mkRenamedOptionModule [ "services" "mattermost" "localDatabaseCreate" ] [ "services" "mattermost" "database" "create" ])
    (mkRenamedOptionModule [ "services" "mattermost" "localDatabasePassword" ] [ "services" "mattermost" "database" "password" ])
    (mkRenamedOptionModule [ "services" "mattermost" "localDatabaseUser" ] [ "services" "mattermost" "database" "user" ])
    (mkRenamedOptionModule [ "services" "mattermost" "localDatabaseName" ] [ "services" "mattermost" "database" "name" ])
    (mkRenamedOptionModule [ "services" "mattermost" "extraConfig" ] [ "services" "mattermost" "settings" ])
    (mkRenamedOptionModule [ "services" "mattermost" "statePath" ] [ "services" "mattermost" "dataDir" ])
  ];

  options = {
    services.mattermost = {
      enable = mkEnableOption "Mattermost chat server";

      package = mkPackageOption pkgs "mattermost" { };

      siteUrl = mkOption {
        type = types.str;
        example = "https://chat.example.com";
        description = ''
          URL this Mattermost instance is reachable under, without trailing slash.
        '';
      };

      siteName = mkOption {
        type = types.str;
        default = "Mattermost";
        description = "Name of this Mattermost site.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          Host or address that this Mattermost instance listens on.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8065;
        description = ''
          Port for Mattermost server to listen on.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/mattermost";
        description = ''
          Mattermost working directory.
        '';
      };

      logDir = mkOption {
        type = types.str;
        default = "/var/log/mattermost";
        description = ''
          Mattermost log directory.
        '';
      };

      configDir = mkOption {
        type = types.str;
        default = "/etc/mattermost";
        description = ''
          Mattermost config directory.
        '';
      };

      mutableConfig = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether the Mattermost config.json is writeable by Mattermost.

          Most of the settings can be edited in the system console of
          Mattermost if this option is enabled. A template config using
          the options specified in services.mattermost will be generated
          but won't be overwritten on changes or rebuilds.

          If this option is disabled, changes in the system console won't
          be possible (default). If an config.json is present, it will be
          overwritten!
        '';
      };

      preferNixConfig = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If both mutableConfig and this option are set, the Nix configuration
          will take precedence over any settings configured in the server
          console.
        '';
      };

      plugins = mkOption {
        type = with types; listOf (either path package);
        default = [];
        example = "[ ./com.github.moussetc.mattermost.plugin.giphy-2.0.0.tar.gz ]";
        description = ''
          Plugins to add to the configuration. Overrides any installed if non-null.
          This is a list of paths to .tar.gz files or derivations evaluating to
          .tar.gz files.
        '';
      };
      environmentFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = ''
          Environment file (see {manpage}`systemd.exec(5)`
          "EnvironmentFile=" section for the syntax) which sets config options
          for mattermost (see [the mattermost documentation](https://docs.mattermost.com/configure/configuration-settings.html#environment-variables)).

          Settings defined in the environment file will overwrite settings
          set via nix or via the {option}`services.mattermost.extraConfig`
          option.

          Useful for setting config options without their value ending up in the
          (world-readable) nix store, e.g. for a database password.
        '';
      };

      database = {
        create = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Create a local PostgreSQL database for Mattermost automatically.
          '';
        };

        peerAuth = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If set, will use peer auth instead of connecting to a Postgres server.
            Use services.mattermost.database.socketPath to configure the socket path.
          '';
        };

        socketPath = mkOption {
          type = types.path;
          default = "/run/postgresql";
          description = ''
            The Postgres socket path.
          '';
        };

        fromEnvironment = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Use services.mattermost.environmentFile to configure the database instead of writing the database URI
            to the Nix store. Useful if you use password authentication with peerAuth set to false.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "mattermost";
          description = ''
            Local Mattermost database name.
          '';
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          example = "127.0.0.1";
          description = ''
            Host to use for the Postgres database. If this is a path, this
            will use socket authentication and ignore the port.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 5432;
          description = ''
            Port to use for the Postgres database.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "mattermost";
          description = ''
            Local Mattermost database username.
          '';
        };

        password = mkOption {
          type = types.str;
          default = "mmpgsecret";
          description = ''
            Password for local Mattermost database user. If set and `host` is not a path,
            will cause a warning nagging you to use environmentFile instead.
          '';
        };

        extraConnectionOptions = mkOption {
          type = with types; attrsOf (either int str);
          default = {
            sslmode = "disable";
            connect_timeout = 10;
          };
          description = ''
            Extra options that are placed in the connection URI's query parameters.
          '';
        };
      };

      user = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          User which runs the Mattermost service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          Group which runs the Mattermost service.
        '';
      };

      settings = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Additional configuration options as Nix attribute set in config.json schema.
        '';
      };

      matterircd = {
        enable = mkEnableOption "Mattermost IRC bridge";
        package = mkPackageOption pkgs "matterircd" { };
        parameters = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "-mmserver chat.example.com" "-bind [::]:6667" ];
          description = ''
            Set commandline parameters to pass to matterircd. See
            https://github.com/42wim/matterircd#usage for more information.
          '';
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      users.users.${cfg.user} = {
        group = cfg.group;
        uid = config.ids.uids.mattermost;
        home = cfg.dataDir;
      };

      users.groups.${cfg.group} = {
        gid = config.ids.gids.mattermost;
      };

      services.postgresql = mkIf cfg.database.create {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [{
          name = throwIf (cfg.database.peerAuth && (cfg.database.user != cfg.user || cfg.database.name != cfg.database.user)) ''
            Mattermost database peer auth is enabled and the user, database user, or database name mismatch.
            Peer authentication will not work.
          '' cfg.database.user;
          ensureDBOwnership = true;
        }];
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.logDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.configDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${mutableDataDir} 0750 ${cfg.user} ${cfg.group} - -"

        # Remove and recreate tempDir.
        "R ${tempDir} - - - - -"
        "d ${tempDir} 0750 ${cfg.user} ${cfg.group} - -"

        # Ensure that pluginDir is a directory, as it could be a symlink on prior versions.
        "r ${pluginDir} - - - - -"
        "d ${pluginDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${mattermostConf.PluginSettings.Directory} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${mattermostConf.PluginSettings.ClientDirectory} 0750 ${cfg.user} ${cfg.group} - -"

        "L+ ${cfg.dataDir}/fonts - - - - ${cfg.package}/fonts"
        "L+ ${cfg.dataDir}/i18n - - - - ${cfg.package}/i18n"
        "L+ ${cfg.dataDir}/templates - - - - ${cfg.package}/templates"
        "L+ ${cfg.dataDir}/client - - - - ${cfg.package}/client"
      ] ++ (
        if mattermostPlugins == null then
          # Create the plugin tarball directory if it's a symlink.
          [
            "r ${cfg.dataDir}/plugins - - - - -"
            "d ${cfg.dataDir}/plugins 0750 ${cfg.user} ${cfg.group} - -"
          ]
        else
          # Symlink the plugin tarball directory.
          ["L+ ${cfg.dataDir}/plugins - - - - ${mattermostPlugins}"]
      );

      systemd.services.mattermost = {
        description = "Mattermost chat service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "postgresql.service" ];
        requires = [ "network.target" "postgresql.service" ];

        # Use tempDir as this can get rather large, especially if Mattermost unpacks a large number of plugins.
        environment.TMPDIR = tempDir;

        preStart = ''
          if [ -f ${cfg.dataDir}/config/config.json ] && [ ! -f ${cfg.configDir}/config.json ]; then
            # Migrate the old config location to the new config location
            cp ${cfg.dataDir}/config/config.json ${cfg.configDir}/config.json
            touch "${cfg.configDir}/.initial-created"
          fi
        '' + lib.optionalString (!cfg.mutableConfig) ''
          ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.configDir}/config.json"
        '' + lib.optionalString cfg.mutableConfig ''
          if [ ! -e "${cfg.configDir}/.initial-created" ]; then
            ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.configDir}/config.json"
            touch "${cfg.configDir}/.initial-created"
          fi
        '' + lib.optionalString (cfg.mutableConfig && cfg.preferNixConfig) ''
          echo "$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "${cfg.configDir}/config.json" ${mattermostConfJSON})" > "${cfg.configDir}/config.json"
        '';

        serviceConfig = mkMerge [
          {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${cfg.package}/bin/mattermost --config ${cfg.configDir}/config.json";
            ReadWritePaths = [ cfg.dataDir cfg.logDir cfg.configDir ];
            UMask = "0027";
            Restart = "always";
            RestartSec = 10;
            LimitNOFILE = 49152;
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            RestrictNamespaces = true;
            RestrictSUIDSGID = true;
            EnvironmentFile = cfg.environmentFile;
            WorkingDirectory = cfg.dataDir;
          }
          (mkIf (cfg.dataDir == "/var/lib/mattermost") {
            StateDirectory = baseNameOf cfg.dataDir;
            StateDirectoryMode = "0750";
          })
          (mkIf (cfg.logDir == "/var/log/mattermost") {
            LogsDirectory = baseNameOf cfg.logDir;
            LogsDirectoryMode = "0750";
          })
          (mkIf (cfg.configDir == "/etc/mattermost") {
            ConfigurationDirectory = baseNameOf cfg.configDir;
            ConfigurationDirectoryMode = "0750";
          })
        ];

        unitConfig.JoinsNamespaceOf = mkIf cfg.database.create "postgresql.service";
      };

      assertions = [
        {
          # Make sure the URL doesn't have a trailing slash
          assertion = !(hasSuffix "/" cfg.siteUrl);
          message = ''
            host or listenAddress should not include a port, use services.mattermost.host and services.mattermost.port to specify the port.
          '';
        }
        {
          # Make sure this isn't a host/port pair
          assertion = !(hasInfix ":" cfg.host && !(hasInfix "[" cfg.host) && !(hasInfix "]" cfg.host));
          message = ''
            host or listenAddress should not include a port, use services.mattermost.host and services.mattermost.port to specify the port.
          '';
        }
      ];
    })
    (mkIf cfg.matterircd.enable {
      systemd.services.matterircd = {
        description = "Mattermost IRC bridge service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "nobody";
          Group = "nogroup";
          ExecStart = "${cfg.matterircd.package}/bin/matterircd ${escapeShellArgs cfg.matterircd.parameters}";
          WorkingDirectory = "/tmp";
          PrivateTmp = true;
          Restart = "always";
          RestartSec = "5";
        };
      };
    })
  ];
}
