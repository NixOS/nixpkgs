{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib.strings)
    hasInfix
    hasSuffix
    escapeURL
    concatStringsSep
    escapeShellArg
    escapeShellArgs
    versionAtLeast
    optionalString
    ;

  inherit (lib.meta) getExe;

  inherit (lib.lists) singleton;

  inherit (lib.attrsets) mapAttrsToList recursiveUpdate optionalAttrs;

  inherit (lib.options) mkOption mkPackageOption mkEnableOption;

  inherit (lib.modules)
    mkRenamedOptionModule
    mkMerge
    mkIf
    mkDefault
    ;

  inherit (lib.trivial) warnIf throwIf;

  inherit (lib) types;

  cfg = config.services.mattermost;

  # The directory to store mutable data within dataDir.
  mutableDataDir = "${cfg.dataDir}/data";

  # The plugin directory. Note that this is the *pre-unpack* plugin directory,
  # since Mattermost looks in mutableDataDir for a directory called "plugins".
  # If Mattermost is installed with plugins defined in a Nix configuration, the plugins
  # are symlinked here. Otherwise, this is a real directory and the tarballs are uploaded here.
  pluginTarballDir = "${mutableDataDir}/plugins";

  # We need a different unpack directory for Mattermost to sync things to at launch,
  # since the above may be a symlink to the store.
  pluginUnpackDir = "${mutableDataDir}/.plugins";

  # Mattermost uses this as a staging directory to unpack plugins, among possibly other things.
  # Ensure that it's inside mutableDataDir since it can get rather large.
  tempDir = "${mutableDataDir}/tmp";

  # Creates a database URI.
  mkDatabaseUri =
    {
      scheme,
      user ? null,
      password ? null,
      escapeUserAndPassword ? true,
      host ? null,
      escapeHost ? true,
      port ? null,
      path ? null,
      query ? { },
    }:
    let
      nullToEmpty = val: if val == null then "" else toString val;

      # Converts a list of URI attrs to a query string.
      toQuery = mapAttrsToList (
        name: value: if value == null then null else (escapeURL name) + "=" + (escapeURL (toString value))
      );

      schemePart = if scheme == null then "" else "${escapeURL scheme}://";
      userPart =
        let
          realUser = if escapeUserAndPassword then escapeURL user else user;
          realPassword = if escapeUserAndPassword then escapeURL password else password;
        in
        if user == null && password == null then
          ""
        else if user != null && password != null then
          "${realUser}:${realPassword}"
        else if user != null then
          realUser
        else
          throw "Either user or username and password must be provided";
      hostPart =
        let
          realHost = if escapeHost then escapeURL (nullToEmpty host) else nullToEmpty host;
        in
        if userPart == "" then realHost else "@" + realHost;
      portPart = if port == null then "" else ":" + (toString port);
      pathPart = if path == null then "" else "/" + path;
      queryPart = if query == { } then "" else "?" + concatStringsSep "&" (toQuery query);
    in
    schemePart + userPart + hostPart + portPart + pathPart + queryPart;

  database =
    let
      hostIsPath = hasInfix "/" cfg.database.host;
    in
    if cfg.database.driver == "postgres" then
      if cfg.database.peerAuth then
        mkDatabaseUri {
          scheme = cfg.database.driver;
          inherit (cfg.database) user;
          path = escapeURL cfg.database.name;
          query = {
            host = cfg.database.socketPath;
          }
          // cfg.database.extraConnectionOptions;
        }
      else
        mkDatabaseUri {
          scheme = cfg.database.driver;
          inherit (cfg.database) user password;
          host = if hostIsPath then null else cfg.database.host;
          port = if hostIsPath then null else cfg.database.port;
          path = escapeURL cfg.database.name;
          query =
            optionalAttrs hostIsPath { host = cfg.database.host; } // cfg.database.extraConnectionOptions;
        }
    else if cfg.database.driver == "mysql" then
      if cfg.database.peerAuth then
        mkDatabaseUri {
          scheme = null;
          inherit (cfg.database) user;
          escapeUserAndPassword = false;
          host = "unix(${cfg.database.socketPath})";
          escapeHost = false;
          path = escapeURL cfg.database.name;
          query = cfg.database.extraConnectionOptions;
        }
      else
        mkDatabaseUri {
          scheme = null;
          inherit (cfg.database) user password;
          escapeUserAndPassword = false;
          host =
            if hostIsPath then
              "unix(${cfg.database.host})"
            else
              "tcp(${cfg.database.host}:${toString cfg.database.port})";
          escapeHost = false;
          path = escapeURL cfg.database.name;
          query = cfg.database.extraConnectionOptions;
        }
    else
      throw "Invalid database driver: ${cfg.database.driver}";

  mattermostPluginDerivations = map (
    plugin:
    pkgs.stdenvNoCC.mkDerivation {
      name = "${cfg.package.name}-plugin";
      installPhase = ''
        runHook preInstall
        mkdir -p $out/share
        ln -sf ${plugin} $out/share/plugin.tar.gz
        runHook postInstall
      '';
      dontUnpack = true;
      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;
      preferLocalBuild = true;
    }
  ) cfg.plugins;

  mattermostPlugins =
    if mattermostPluginDerivations == [ ] then
      null
    else
      pkgs.stdenvNoCC.mkDerivation {
        name = "${cfg.package.name}-plugins";
        nativeBuildInputs = [ pkgs.autoPatchelfHook ] ++ mattermostPluginDerivations;
        buildInputs = [ cfg.package ];
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          plugins=(${
            escapeShellArgs (map (plugin: "${plugin}/share/plugin.tar.gz") mattermostPluginDerivations)
          })
          for plugin in "''${plugins[@]}"; do
            hash="$(sha256sum "$plugin" | awk '{print $1}')"
            mkdir -p "$hash"
            tar -C "$hash" -xzf "$plugin"
            autoPatchelf "$hash"
            GZIP_OPT=-9 tar -C "$hash" -cvzf "$out/$hash.tar.gz" .
            rm -rf "$hash"
          done
          runHook postInstall
        '';

        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        preferLocalBuild = true;
      };

  mattermostConfWithoutPlugins = recursiveUpdate {
    ServiceSettings = {
      SiteURL = cfg.siteUrl;
      ListenAddress = "${cfg.host}:${toString cfg.port}";
      LocalModeSocketLocation = cfg.socket.path;
      EnableLocalMode = cfg.socket.enable;
      EnableSecurityFixAlert = cfg.telemetry.enableSecurityAlerts;
    };
    TeamSettings.SiteName = cfg.siteName;
    SqlSettings.DriverName = cfg.database.driver;
    SqlSettings.DataSource =
      if cfg.database.fromEnvironment then
        null
      else
        warnIf (!cfg.database.peerAuth && cfg.database.password != null) ''
          Database password is set in Mattermost config! This password will end up in the Nix store.

          You may be able to simply set the following, if the database is on the same host
          and peer authentication is enabled:

          services.mattermost.database.peerAuth = true;

          Note that this is the default if you set system.stateVersion to 25.05 or later
          and the database host is localhost.

          Alternatively, you can write the following to ${
            if cfg.environmentFile == null then "your environment file" else cfg.environmentFile
          }:

          MM_SQLSETTINGS_DATASOURCE=${database}

          Then set the following options:
          services.mattermost.environmentFile = "<your environment file>";
          services.mattermost.database.fromEnvironment = true;
        '' database;

    # Note that the plugin tarball directory is not configurable, and is expected to be in FileSettings.Directory/plugins.
    FileSettings.Directory = mutableDataDir;
    PluginSettings.Directory = "${pluginUnpackDir}/server";
    PluginSettings.ClientDirectory = "${pluginUnpackDir}/client";

    LogSettings = {
      FileLocation = cfg.logDir;

      # Reaches out to Mattermost's servers for telemetry; disable it by default.
      # https://docs.mattermost.com/configure/environment-configuration-settings.html#enable-diagnostics-and-error-reporting
      EnableDiagnostics = cfg.telemetry.enableDiagnostics;
    };
  } cfg.settings;

  mattermostConf = recursiveUpdate mattermostConfWithoutPlugins (
    if mattermostPlugins == null then
      { }
    else
      {
        PluginSettings = {
          Enable = true;
        };
      }
  );

  format = pkgs.formats.json { };
  finalConfig = format.generate "mattermost-config.json" mattermostConf;
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "mattermost"
        "listenAddress"
      ]
      [
        "services"
        "mattermost"
        "host"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "mattermost"
        "localDatabaseCreate"
      ]
      [
        "services"
        "mattermost"
        "database"
        "create"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "mattermost"
        "localDatabasePassword"
      ]
      [
        "services"
        "mattermost"
        "database"
        "password"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "mattermost"
        "localDatabaseUser"
      ]
      [
        "services"
        "mattermost"
        "database"
        "user"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "mattermost"
        "localDatabaseName"
      ]
      [
        "services"
        "mattermost"
        "database"
        "name"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "mattermost"
        "extraConfig"
      ]
      [
        "services"
        "mattermost"
        "settings"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "mattermost"
        "statePath"
      ]
      [
        "services"
        "mattermost"
        "dataDir"
      ]
    )
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
        type = types.path;
        default = "/var/lib/mattermost";
        description = ''
          Mattermost working directory.
        '';
      };

      socket = {
        enable = mkEnableOption "Mattermost control socket";

        path = mkOption {
          type = types.path;
          default = "${cfg.dataDir}/mattermost.sock";
          defaultText = ''''${config.mattermost.dataDir}/mattermost.sock'';
          description = ''
            Default location for the Mattermost control socket used by `mmctl`.
          '';
        };

        export = mkEnableOption "Export socket control to system environment variables";
      };

      logDir = mkOption {
        type = types.path;
        default =
          if versionAtLeast config.system.stateVersion "25.05" then
            "/var/log/mattermost"
          else
            "${cfg.dataDir}/logs";
        defaultText = ''
          if versionAtLeast config.system.stateVersion "25.05" then "/var/log/mattermost"
          else "''${config.services.mattermost.dataDir}/logs";
        '';
        description = ''
          Mattermost log directory.
        '';
      };

      configDir = mkOption {
        type = types.path;
        default =
          if versionAtLeast config.system.stateVersion "25.05" then
            "/etc/mattermost"
          else
            "${cfg.dataDir}/config";
        defaultText = ''
          if versionAtLeast config.system.stateVersion "25.05" then
            "/etc/mattermost"
          else
            "''${config.services.mattermost.dataDir}/config";
        '';
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

          If this option is disabled, persistent changes in the system
          console won't be possible (the default). If a config.json is
          present, it will be overwritten at service start!
        '';
      };

      preferNixConfig = mkOption {
        type = types.bool;
        default = versionAtLeast config.system.stateVersion "25.05";
        defaultText = ''
          versionAtLeast config.system.stateVersion "25.05";
        '';
        description = ''
          If both mutableConfig and this option are set, the Nix configuration
          will take precedence over any settings configured in the server
          console.
        '';
      };

      plugins = mkOption {
        type = with types; listOf (either path package);
        default = [ ];
        example = "[ ./com.github.moussetc.mattermost.plugin.giphy-2.0.0.tar.gz ]";
        description = ''
          Plugins to add to the configuration. Overrides any installed if non-null.
          This is a list of paths to .tar.gz files or derivations evaluating to
          .tar.gz files. You can use `mattermost.buildPlugin` to build plugins;
          see the NixOS documentation for more details.
        '';
      };

      pluginsBundle = mkOption {
        type = with types; nullOr package;
        default = mattermostPlugins;
        defaultText = ''
          All entries in {config}`services.mattermost.plugins`, repacked
        '';
        description = ''
          Derivation building to a directory of plugin tarballs.
          This overrides {option}`services.mattermost.plugins` if provided.
        '';
      };

      telemetry = {
        enableSecurityAlerts = mkOption {
          type = types.bool;
          default = true;
          description = ''
            True if we should enable security update checking. This reaches out to Mattermost's servers:
            https://docs.mattermost.com/manage/telemetry.html#security-update-check-feature
          '';
        };

        enableDiagnostics = mkOption {
          type = types.bool;
          default = false;
          description = ''
            True if we should enable sending diagnostic data. This reaches out to Mattermost's servers:
            https://docs.mattermost.com/manage/telemetry.html#error-and-diagnostics-reporting-feature
          '';
        };
      };

      environment = mkOption {
        type = with types; attrsOf (either int str);
        default = { };
        description = ''
          Extra environment variables to export to the Mattermost process
          from the systemd unit configuration.
        '';
        example = {
          MM_SERVICESETTINGS_SITEURL = "http://example.com";
        };
      };

      environmentFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = ''
          Environment file (see {manpage}`systemd.exec(5)`
          "EnvironmentFile=" section for the syntax) which sets config options
          for mattermost (see [the Mattermost documentation](https://docs.mattermost.com/configure/configuration-settings.html#environment-variables)).

          Settings defined in the environment file will overwrite settings
          set via Nix or via the {option}`services.mattermost.extraConfig`
          option.

          Useful for setting config options without their value ending up in the
          (world-readable) Nix store, e.g. for a database password.
        '';
      };

      database = {
        driver = mkOption {
          type = types.enum [
            "postgres"
            "mysql"
          ];
          default = "postgres";
          description = ''
            The database driver to use (Postgres or MySQL).
          '';
        };

        create = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Create a local PostgreSQL or MySQL database for Mattermost automatically.
          '';
        };

        peerAuth = mkOption {
          type = types.bool;
          default = versionAtLeast config.system.stateVersion "25.05" && cfg.database.host == "localhost";
          defaultText = ''
            versionAtLeast config.system.stateVersion "25.05" && config.services.mattermost.database.host == "localhost"
          '';
          description = ''
            If set, will use peer auth instead of connecting to a Postgres server.
            Use services.mattermost.database.socketPath to configure the socket path.
          '';
        };

        socketPath = mkOption {
          type = types.path;
          default =
            if cfg.database.driver == "postgres" then "/run/postgresql" else "/run/mysqld/mysqld.sock";
          defaultText = ''
            if config.services.mattermost.database.driver == "postgres" then "/run/postgresql" else "/run/mysqld/mysqld.sock";
          '';
          description = ''
            The database (Postgres or MySQL) socket path.
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
            Host to use for the database. Can also be set to a path if you'd like to connect
            to a socket using a username and password.
          '';
        };

        port = mkOption {
          type = types.port;
          default = if cfg.database.driver == "postgres" then 5432 else 3306;
          defaultText = ''
            if config.services.mattermost.database.type == "postgres" then 5432 else 3306
          '';
          example = 3306;
          description = ''
            Port to use for the database.
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
            Password for local Mattermost database user. If set and peerAuth is not true,
            will cause a warning nagging you to use environmentFile instead since it will
            end up in the Nix store.
          '';
        };

        extraConnectionOptions = mkOption {
          type = with types; attrsOf (either int str);
          default =
            if cfg.database.driver == "postgres" then
              {
                sslmode = "disable";
                connect_timeout = 60;
              }
            else if cfg.database.driver == "mysql" then
              {
                charset = "utf8mb4";
                writeTimeout = "60s";
                readTimeout = "60s";
              }
            else
              throw "Invalid database driver ${cfg.database.driver}";
          defaultText = ''
            if config.mattermost.database.driver == "postgres" then
              {
                sslmode = "disable";
                connect_timeout = 60;
              }
            else if config.mattermost.database.driver == "mysql" then
              {
                charset = "utf8mb4";
                writeTimeout = "60s";
                readTimeout = "60s";
              }
            else
              throw "Invalid database driver";
          '';
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
        inherit (format) type;
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
          example = [
            "-mmserver chat.example.com"
            "-bind [::]:6667"
          ];
          description = ''
            Set commandline parameters to pass to matterircd. See
            <https://github.com/42wim/matterircd#usage> for more information.
          '';
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      users.users = {
        ${cfg.user} = {
          group = cfg.group;
          uid = mkIf (cfg.user == "mattermost") config.ids.uids.mattermost;
          home = cfg.dataDir;
          isSystemUser = true;
          packages = [ cfg.package ];
        };
      };

      users.groups = {
        ${cfg.group} = {
          gid = mkIf (cfg.group == "mattermost") config.ids.gids.mattermost;
        };
      };

      services.postgresql = mkIf (cfg.database.driver == "postgres" && cfg.database.create) {
        enable = true;
        ensureDatabases = singleton cfg.database.name;
        ensureUsers = singleton {
          name =
            throwIf
              (cfg.database.peerAuth && (cfg.database.user != cfg.user || cfg.database.name != cfg.database.user))
              ''
                Mattermost database peer auth is enabled and the user, database user, or database name mismatch.
                Peer authentication will not work.
              ''
              cfg.database.user;
          ensureDBOwnership = true;
        };
      };

      services.mysql = mkIf (cfg.database.driver == "mysql" && cfg.database.create) {
        enable = true;
        package = mkDefault pkgs.mariadb;
        ensureDatabases = singleton cfg.database.name;
        ensureUsers = singleton {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        };
        settings = rec {
          mysqld = {
            collation-server = mkDefault "utf8mb4_general_ci";
            init-connect = mkDefault "SET NAMES utf8mb4";
            character-set-server = mkDefault "utf8mb4";
          };
          mysqld_safe = mysqld;
        };
      };

      environment = {
        variables = mkIf cfg.socket.export {
          MMCTL_LOCAL = "true";
          MMCTL_LOCAL_SOCKET_PATH = cfg.socket.path;
        };
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.logDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.configDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${mutableDataDir} 0750 ${cfg.user} ${cfg.group} - -"

        # Make sure tempDir exists and is not a symlink.
        "R- ${tempDir} - - - - -"
        "d= ${tempDir} 0750 ${cfg.user} ${cfg.group} - -"

        # Ensure that pluginUnpackDir is a directory.
        # Don't remove or clean it out since it should be persistent, as this is where plugins are unpacked.
        "d= ${pluginUnpackDir} 0750 ${cfg.user} ${cfg.group} - -"

        # Ensure that the plugin directories exist.
        "d= ${mattermostConf.PluginSettings.Directory} 0750 ${cfg.user} ${cfg.group} - -"
        "d= ${mattermostConf.PluginSettings.ClientDirectory} 0750 ${cfg.user} ${cfg.group} - -"

        # Link in some of the immutable data directories.
        "L+ ${cfg.dataDir}/bin - - - - ${cfg.package}/bin"
        "L+ ${cfg.dataDir}/fonts - - - - ${cfg.package}/fonts"
        "L+ ${cfg.dataDir}/i18n - - - - ${cfg.package}/i18n"
        "L+ ${cfg.dataDir}/templates - - - - ${cfg.package}/templates"
        "L+ ${cfg.dataDir}/client - - - - ${cfg.package}/client"
      ]
      ++ (
        if cfg.pluginsBundle == null then
          # Create the plugin tarball directory to allow plugin uploads.
          [
            "d= ${pluginTarballDir} 0750 ${cfg.user} ${cfg.group} - -"
          ]
        else
          # Symlink the plugin tarball directory, removing anything existing, since it's managed by Nix.
          [ "L+ ${pluginTarballDir} - - - - ${cfg.pluginsBundle}" ]
      );

      systemd.services.mattermost = rec {
        description = "Mattermost chat service";
        wantedBy = [ "multi-user.target" ];
        after = mkMerge [
          [ "network.target" ]
          (mkIf (cfg.database.driver == "postgres" && cfg.database.create) [ "postgresql.target" ])
          (mkIf (cfg.database.driver == "mysql" && cfg.database.create) [ "mysql.service" ])
        ];
        requires = after;

        environment = mkMerge [
          {
            # Use tempDir as this can get rather large, especially if Mattermost unpacks a large number of plugins.
            TMPDIR = tempDir;
          }
          cfg.environment
        ];

        preStart = ''
          dataDir=${escapeShellArg cfg.dataDir}
          configDir=${escapeShellArg cfg.configDir}
          logDir=${escapeShellArg cfg.logDir}
          package=${escapeShellArg cfg.package}
          nixConfig=${escapeShellArg finalConfig}
        ''
        + optionalString (versionAtLeast config.system.stateVersion "25.05") ''
          # Migrate configs in the pre-25.05 directory structure.
          oldConfig="$dataDir/config/config.json"
          newConfig="$configDir/config.json"
          if [ "$oldConfig" != "$newConfig" ] && [ -f "$oldConfig" ] && [ ! -f "$newConfig" ]; then
            # Migrate the legacy config location to the new config location
            echo "Moving legacy config at $oldConfig to $newConfig" >&2
            mkdir -p "$configDir"
            mv "$oldConfig" "$newConfig"
            touch "$configDir/.initial-created"
          fi

          # Logs too.
          oldLogs="$dataDir/logs"
          newLogs="$logDir"
          if [ "$oldLogs" != "$newLogs" ] && [ -d "$oldLogs" ] && [ ! -f "$newLogs/.initial-created" ]; then
            # Migrate the legacy log location to the new log location.
            # Allow this to fail if there aren't any logs to move.
            echo "Moving legacy logs at $oldLogs to $newLogs" >&2
            mkdir -p "$newLogs"
            mv "$oldLogs"/* "$newLogs" || true
            touch "$newLogs/.initial-created"
          fi
        ''
        + optionalString (!cfg.mutableConfig) ''
          ${getExe pkgs.jq} -s '.[0] * .[1]' "$package/config/config.json" "$nixConfig" > "$configDir/config.json"
        ''
        + optionalString cfg.mutableConfig ''
          if [ ! -e "$configDir/.initial-created" ]; then
            ${getExe pkgs.jq} -s '.[0] * .[1]' "$package/config/config.json" "$nixConfig" > "$configDir/config.json"
            touch "$configDir/.initial-created"
          fi
        ''
        + optionalString (cfg.mutableConfig && cfg.preferNixConfig) ''
          echo "$(${getExe pkgs.jq} -s '.[0] * .[1]' "$configDir/config.json" "$nixConfig")" > "$configDir/config.json"
        '';

        serviceConfig = mkMerge [
          {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${getExe cfg.package} --config ${cfg.configDir}/config.json";
            ReadWritePaths = [
              cfg.dataDir
              cfg.logDir
              cfg.configDir
            ];
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

        unitConfig.JoinsNamespaceOf = mkMerge [
          (mkIf (cfg.database.driver == "postgres" && cfg.database.create) [ "postgresql.target" ])
          (mkIf (cfg.database.driver == "mysql" && cfg.database.create) [ "mysql.service" ])
        ];
      };

      assertions = [
        {
          # Make sure the URL doesn't have a trailing slash
          assertion = !(hasSuffix "/" cfg.siteUrl);
          message = ''
            services.mattermost.siteUrl should not have a trailing "/".
          '';
        }
        {
          # Make sure this isn't a host/port pair
          assertion = !(hasInfix ":" cfg.host && !(hasInfix "[" cfg.host) && !(hasInfix "]" cfg.host));
          message = ''
            services.mattermost.host should not include a port. Use services.mattermost.host for the address
            or hostname, and services.mattermost.port to specify the port separately.
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
          ExecStart = "${getExe cfg.matterircd.package} ${escapeShellArgs cfg.matterircd.parameters}";
          WorkingDirectory = "/tmp";
          PrivateTmp = true;
          Restart = "always";
          RestartSec = "5";
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [ numinit ];
}
