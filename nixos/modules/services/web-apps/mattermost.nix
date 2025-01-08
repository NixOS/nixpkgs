{
  config,
  pkgs,
  lib,
  ...
}:

let

  cfg = config.services.mattermost;

  database = "postgres://${cfg.localDatabaseUser}:${cfg.localDatabasePassword}@localhost:5432/${cfg.localDatabaseName}?sslmode=disable&connect_timeout=10";

  postgresPackage = config.services.postgresql.package;

  createDb =
    {
      statePath ? cfg.statePath,
      localDatabaseUser ? cfg.localDatabaseUser,
      localDatabasePassword ? cfg.localDatabasePassword,
      localDatabaseName ? cfg.localDatabaseName,
      useSudo ? true,
    }:
    ''
      if ! test -e ${lib.escapeShellArg "${statePath}/.db-created"}; then
        ${lib.optionalString useSudo "${pkgs.sudo}/bin/sudo -u ${lib.escapeShellArg config.services.postgresql.superUser} \\"}
          ${postgresPackage}/bin/psql postgres -c \
            "CREATE ROLE ${localDatabaseUser} WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${localDatabasePassword}'"
        ${lib.optionalString useSudo "${pkgs.sudo}/bin/sudo -u ${lib.escapeShellArg config.services.postgresql.superUser} \\"}
          ${postgresPackage}/bin/createdb \
            --owner ${lib.escapeShellArg localDatabaseUser} ${lib.escapeShellArg localDatabaseName}
        touch ${lib.escapeShellArg "${statePath}/.db-created"}
      fi
    '';

  mattermostPluginDerivations =
    with pkgs;
    map (
      plugin:
      stdenv.mkDerivation {
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
      }
    ) cfg.plugins;

  mattermostPlugins =
    with pkgs;
    if mattermostPluginDerivations == [ ] then
      null
    else
      stdenv.mkDerivation {
        name = "${cfg.package.name}-plugins";
        nativeBuildInputs = [
          autoPatchelfHook
        ] ++ mattermostPluginDerivations;
        buildInputs = [
          cfg.package
        ];
        installPhase = ''
          mkdir -p $out/data/plugins
          plugins=(${
            escapeShellArgs (map (plugin: "${plugin}/share/plugin.tar.gz") mattermostPluginDerivations)
          })
          for plugin in "''${plugins[@]}"; do
            hash="$(sha256sum "$plugin" | cut -d' ' -f1)"
            mkdir -p "$hash"
            tar -C "$hash" -xzf "$plugin"
            autoPatchelf "$hash"
            GZIP_OPT=-9 tar -C "$hash" -cvzf "$out/data/plugins/$hash.tar.gz" .
            rm -rf "$hash"
          done
        '';

        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        preferLocalBuild = true;
      };

  mattermostConfWithoutPlugins = lib.recursiveUpdate {
    ServiceSettings.SiteURL = cfg.siteUrl;
    ServiceSettings.ListenAddress = cfg.listenAddress;
    TeamSettings.SiteName = cfg.siteName;
    SqlSettings.DriverName = "postgres";
    SqlSettings.DataSource = database;
    PluginSettings.Directory = "${cfg.statePath}/plugins/server";
    PluginSettings.ClientDirectory = "${cfg.statePath}/plugins/client";
  } cfg.extraConfig;

  mattermostConf = lib.recursiveUpdate mattermostConfWithoutPlugins (
    lib.optionalAttrs (mattermostPlugins != null) {
      PluginSettings = {
        Enable = true;
      };
    }
  );

  mattermostConfJSON = pkgs.writeText "mattermost-config.json" (builtins.toJSON mattermostConf);

in

{
  options = {
    services.mattermost = {
      enable = lib.mkEnableOption "Mattermost chat server";

      package = lib.mkPackageOption pkgs "mattermost" { };

      statePath = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/mattermost";
        description = "Mattermost working directory";
      };

      siteUrl = lib.mkOption {
        type = lib.types.str;
        example = "https://chat.example.com";
        description = ''
          URL this Mattermost instance is reachable under, without trailing slash.
        '';
      };

      siteName = lib.mkOption {
        type = lib.types.str;
        default = "Mattermost";
        description = "Name of this Mattermost site.";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = ":8065";
        example = "[::1]:8065";
        description = ''
          Address and port this Mattermost instance listens to.
        '';
      };

      mutableConfig = lib.mkOption {
        type = lib.types.bool;
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

      preferNixConfig = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If both mutableConfig and this option are set, the Nix configuration
          will take precedence over any settings configured in the server
          console.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = ''
          Additional configuration options as Nix attribute set in config.json schema.
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.listOf (
          lib.types.oneOf [
            lib.types.path
            lib.types.package
          ]
        );
        default = [ ];
        example = "[ ./com.github.moussetc.mattermost.plugin.giphy-2.0.0.tar.gz ]";
        description = ''
          Plugins to add to the configuration. Overrides any installed if non-null.
          This is a list of paths to .tar.gz files or derivations evaluating to
          .tar.gz files.
        '';
      };
      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
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

      localDatabaseCreate = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Create a local PostgreSQL database for Mattermost automatically.
        '';
      };

      localDatabaseName = lib.mkOption {
        type = lib.types.str;
        default = "mattermost";
        description = ''
          Local Mattermost database name.
        '';
      };

      localDatabaseUser = lib.mkOption {
        type = lib.types.str;
        default = "mattermost";
        description = ''
          Local Mattermost database username.
        '';
      };

      localDatabasePassword = lib.mkOption {
        type = lib.types.str;
        default = "mmpgsecret";
        description = ''
          Password for local Mattermost database user.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "mattermost";
        description = ''
          User which runs the Mattermost service.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "mattermost";
        description = ''
          Group which runs the Mattermost service.
        '';
      };

      matterircd = {
        enable = lib.mkEnableOption "Mattermost IRC bridge";
        package = lib.mkPackageOption pkgs "matterircd" { };
        parameters = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "-mmserver chat.example.com"
            "-bind [::]:6667"
          ];
          description = ''
            Set commandline parameters to pass to matterircd. See
            https://github.com/42wim/matterircd#usage for more information.
          '';
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      users.users = lib.optionalAttrs (cfg.user == "mattermost") {
        mattermost = {
          group = cfg.group;
          uid = config.ids.uids.mattermost;
          home = cfg.statePath;
        };
      };

      users.groups = lib.optionalAttrs (cfg.group == "mattermost") {
        mattermost.gid = config.ids.gids.mattermost;
      };

      services.postgresql.enable = cfg.localDatabaseCreate;

      # The systemd service will fail to execute the preStart hook
      # if the WorkingDirectory does not exist
      systemd.tmpfiles.settings."10-mattermost".${cfg.statePath}.d = { };

      systemd.services.mattermost = {
        description = "Mattermost chat service";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "postgresql.service"
        ];

        preStart =
          ''
            mkdir -p "${cfg.statePath}"/{data,config,logs,plugins}
            mkdir -p "${cfg.statePath}/plugins"/{client,server}
            ln -sf ${cfg.package}/{bin,fonts,i18n,templates,client} "${cfg.statePath}"
          ''
          + lib.optionalString (mattermostPlugins != null) ''
            rm -rf "${cfg.statePath}/data/plugins"
            ln -sf ${mattermostPlugins}/data/plugins "${cfg.statePath}/data"
          ''
          + lib.optionalString (!cfg.mutableConfig) ''
            rm -f "${cfg.statePath}/config/config.json"
            ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.statePath}/config/config.json"
          ''
          + lib.optionalString cfg.mutableConfig ''
            if ! test -e "${cfg.statePath}/config/.initial-created"; then
              rm -f ${cfg.statePath}/config/config.json
              ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.statePath}/config/config.json"
              touch "${cfg.statePath}/config/.initial-created"
            fi
          ''
          + lib.optionalString (cfg.mutableConfig && cfg.preferNixConfig) ''
            new_config="$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "${cfg.statePath}/config/config.json" ${mattermostConfJSON})"

            rm -f "${cfg.statePath}/config/config.json"
            echo "$new_config" > "${cfg.statePath}/config/config.json"
          ''
          + lib.optionalString cfg.localDatabaseCreate (createDb { })
          + ''
            # Don't change permissions recursively on the data, current, and symlinked directories (see ln -sf command above).
            # This dramatically decreases startup times for installations with a lot of files.
            find . -maxdepth 1 -not -name data -not -name client -not -name templates -not -name i18n -not -name fonts -not -name bin -not -name . \
              -exec chown "${cfg.user}:${cfg.group}" -R {} \; -exec chmod u+rw,g+r,o-rwx -R {} \;

            chown "${cfg.user}:${cfg.group}" "${cfg.statePath}/data" .
            chmod u+rw,g+r,o-rwx "${cfg.statePath}/data" .
          '';

        serviceConfig = {
          PermissionsStartOnly = true;
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${cfg.package}/bin/mattermost";
          WorkingDirectory = "${cfg.statePath}";
          Restart = "always";
          RestartSec = "10";
          LimitNOFILE = "49152";
          EnvironmentFile = cfg.environmentFile;
        };
        unitConfig.JoinsNamespaceOf = lib.mkIf cfg.localDatabaseCreate "postgresql.service";
      };
    })
    (lib.mkIf cfg.matterircd.enable {
      systemd.services.matterircd = {
        description = "Mattermost IRC bridge service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "nobody";
          Group = "nogroup";
          ExecStart = "${cfg.matterircd.package}/bin/matterircd ${lib.escapeShellArgs cfg.matterircd.parameters}";
          WorkingDirectory = "/tmp";
          PrivateTmp = true;
          Restart = "always";
          RestartSec = "5";
        };
      };
    })
  ];
}
