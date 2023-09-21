{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.mattermost;

  database = "postgres://${cfg.localDatabaseUser}:${cfg.localDatabasePassword}@localhost:5432/${cfg.localDatabaseName}?sslmode=disable&connect_timeout=10";

  postgresPackage = config.services.postgresql.package;

  createDb = {
    statePath ? cfg.statePath,
    localDatabaseUser ? cfg.localDatabaseUser,
    localDatabasePassword ? cfg.localDatabasePassword,
    localDatabaseName ? cfg.localDatabaseName,
    useSudo ? true
  }: ''
    if ! test -e ${escapeShellArg "${statePath}/.db-created"}; then
      ${lib.optionalString useSudo "${pkgs.sudo}/bin/sudo -u ${escapeShellArg config.services.postgresql.superUser} \\"}
        ${postgresPackage}/bin/psql postgres -c \
          "CREATE ROLE ${localDatabaseUser} WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${localDatabasePassword}'"
      ${lib.optionalString useSudo "${pkgs.sudo}/bin/sudo -u ${escapeShellArg config.services.postgresql.superUser} \\"}
        ${postgresPackage}/bin/createdb \
          --owner ${escapeShellArg localDatabaseUser} ${escapeShellArg localDatabaseName}
      touch ${escapeShellArg "${statePath}/.db-created"}
    fi
  '';

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
        mkdir -p $out/data/plugins
        plugins=(${escapeShellArgs (map (plugin: "${plugin}/share/plugin.tar.gz") mattermostPluginDerivations)})
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

  mattermostConfWithoutPlugins = recursiveUpdate
    { ServiceSettings.SiteURL = cfg.siteUrl;
      ServiceSettings.ListenAddress = cfg.listenAddress;
      TeamSettings.SiteName = cfg.siteName;
      SqlSettings.DriverName = "postgres";
      SqlSettings.DataSource = database;
      PluginSettings.Directory = "${cfg.statePath}/plugins/server";
      PluginSettings.ClientDirectory = "${cfg.statePath}/plugins/client";
    }
    cfg.extraConfig;

  mattermostConf = recursiveUpdate
    mattermostConfWithoutPlugins
    (
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
      enable = mkEnableOption (lib.mdDoc "Mattermost chat server");

      package = mkOption {
        type = types.package;
        default = pkgs.mattermost;
        defaultText = lib.literalExpression "pkgs.mattermost";
        description = lib.mdDoc "Mattermost derivation to use.";
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/lib/mattermost";
        description = lib.mdDoc "Mattermost working directory";
      };

      siteUrl = mkOption {
        type = types.str;
        example = "https://chat.example.com";
        description = lib.mdDoc ''
          URL this Mattermost instance is reachable under, without trailing slash.
        '';
      };

      siteName = mkOption {
        type = types.str;
        default = "Mattermost";
        description = lib.mdDoc "Name of this Mattermost site.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = ":8065";
        example = "[::1]:8065";
        description = lib.mdDoc ''
          Address and port this Mattermost instance listens to.
        '';
      };

      mutableConfig = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          If both mutableConfig and this option are set, the Nix configuration
          will take precedence over any settings configured in the server
          console.
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        description = lib.mdDoc ''
          Additional configuration options as Nix attribute set in config.json schema.
        '';
      };

      plugins = mkOption {
        type = types.listOf (types.oneOf [types.path types.package]);
        default = [];
        example = "[ ./com.github.moussetc.mattermost.plugin.giphy-2.0.0.tar.gz ]";
        description = lib.mdDoc ''
          Plugins to add to the configuration. Overrides any installed if non-null.
          This is a list of paths to .tar.gz files or derivations evaluating to
          .tar.gz files.
        '';
      };
      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
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

      localDatabaseCreate = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Create a local PostgreSQL database for Mattermost automatically.
        '';
      };

      localDatabaseName = mkOption {
        type = types.str;
        default = "mattermost";
        description = lib.mdDoc ''
          Local Mattermost database name.
        '';
      };

      localDatabaseUser = mkOption {
        type = types.str;
        default = "mattermost";
        description = lib.mdDoc ''
          Local Mattermost database username.
        '';
      };

      localDatabasePassword = mkOption {
        type = types.str;
        default = "mmpgsecret";
        description = lib.mdDoc ''
          Password for local Mattermost database user.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "mattermost";
        description = lib.mdDoc ''
          User which runs the Mattermost service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "mattermost";
        description = lib.mdDoc ''
          Group which runs the Mattermost service.
        '';
      };

      matterircd = {
        enable = mkEnableOption (lib.mdDoc "Mattermost IRC bridge");
        package = mkOption {
          type = types.package;
          default = pkgs.matterircd;
          defaultText = lib.literalExpression "pkgs.matterircd";
          description = lib.mdDoc "matterircd derivation to use.";
        };
        parameters = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "-mmserver chat.example.com" "-bind [::]:6667" ];
          description = lib.mdDoc ''
            Set commandline parameters to pass to matterircd. See
            https://github.com/42wim/matterircd#usage for more information.
          '';
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      users.users = optionalAttrs (cfg.user == "mattermost") {
        mattermost = {
          group = cfg.group;
          uid = config.ids.uids.mattermost;
          home = cfg.statePath;
        };
      };

      users.groups = optionalAttrs (cfg.group == "mattermost") {
        mattermost.gid = config.ids.gids.mattermost;
      };

      services.postgresql.enable = cfg.localDatabaseCreate;

      # The systemd service will fail to execute the preStart hook
      # if the WorkingDirectory does not exist
      system.activationScripts.mattermost = ''
        mkdir -p "${cfg.statePath}"
      '';

      systemd.services.mattermost = {
        description = "Mattermost chat service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "postgresql.service" ];

        preStart = ''
          mkdir -p "${cfg.statePath}"/{data,config,logs,plugins}
          mkdir -p "${cfg.statePath}/plugins"/{client,server}
          ln -sf ${cfg.package}/{bin,fonts,i18n,templates,client} "${cfg.statePath}"
        '' + lib.optionalString (mattermostPlugins != null) ''
          rm -rf "${cfg.statePath}/data/plugins"
          ln -sf ${mattermostPlugins}/data/plugins "${cfg.statePath}/data"
        '' + lib.optionalString (!cfg.mutableConfig) ''
          rm -f "${cfg.statePath}/config/config.json"
          ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.statePath}/config/config.json"
        '' + lib.optionalString cfg.mutableConfig ''
          if ! test -e "${cfg.statePath}/config/.initial-created"; then
            rm -f ${cfg.statePath}/config/config.json
            ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.statePath}/config/config.json"
            touch "${cfg.statePath}/config/.initial-created"
          fi
        '' + lib.optionalString (cfg.mutableConfig && cfg.preferNixConfig) ''
          new_config="$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "${cfg.statePath}/config/config.json" ${mattermostConfJSON})"

          rm -f "${cfg.statePath}/config/config.json"
          echo "$new_config" > "${cfg.statePath}/config/config.json"
        '' + lib.optionalString cfg.localDatabaseCreate (createDb {}) + ''
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
        unitConfig.JoinsNamespaceOf = mkIf cfg.localDatabaseCreate "postgresql.service";
      };
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
