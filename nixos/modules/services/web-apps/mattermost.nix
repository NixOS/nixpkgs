{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.mattermost;

  database = "postgres://${cfg.databaseUser}:${cfg.databasePassword}@${cfg.databaseHost}:${toString cfg.databasePort}/${cfg.databaseName}?sslmode=disable&connect_timeout=10";

  postgresPackage = config.services.postgresql.package;

  createDb = {
    statePath ? cfg.statePath,
    databaseUser ? cfg.databaseUser,
    databasePassword ? cfg.databasePassword,
    databaseName ? cfg.databaseName,
    useSudo ? true
  }: ''
    if ! test -e ${escapeShellArg "${statePath}/.db-created"}; then
      ${lib.optionalString useSudo "${pkgs.sudo}/bin/sudo -u ${escapeShellArg config.services.postgresql.superUser} \\"}
        ${postgresPackage}/bin/psql postgres -c \
          "CREATE ROLE ${databaseUser} WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${databasePassword}'"
      ${lib.optionalString useSudo "${pkgs.sudo}/bin/sudo -u ${escapeShellArg config.services.postgresql.superUser} \\"}
        ${postgresPackage}/bin/createdb \
          --owner ${escapeShellArg databaseUser} ${escapeShellArg databaseName}
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
  options = {
    services.mattermost = {
      enable = mkEnableOption "Mattermost chat server";

      package = mkOption {
        type = types.package;
        default = pkgs.mattermost;
        defaultText = "pkgs.mattermost";
        description = "Mattermost derivation to use.";
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/lib/mattermost";
        description = "Mattermost working directory";
      };

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

      listenAddress = mkOption {
        type = types.str;
        default = ":8065";
        example = "[::1]:8065";
        description = ''
          Address and port this Mattermost instance listens to.
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

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Addtional configuration options as Nix attribute set in config.json schema.
        '';
      };

      plugins = mkOption {
        type = types.listOf (types.oneOf [types.path types.package]);
        default = [];
        example = "[ ./com.github.moussetc.mattermost.plugin.giphy-2.0.0.tar.gz ]";
        description = ''
          Plugins to add to the configuration. Overrides any installed if non-null.
          This is a list of paths to .tar.gz files or derivations evaluating to
          .tar.gz files.
        '';
      };

      databaseCreate = mkOption {
        type = types.bool;
        default = cfg.databaseHost == "localhost";
        defaultText = ''
          config.services.mattermost.databaseHost == "localhost"
        '';
        description = ''
          Create a local PostgreSQL database for Mattermost automatically.
        '';
      };

      databaseName = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          Mattermost database name.
        '';
      };

      databaseUser = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          Mattermost database username.
        '';
      };

      databasePassword = mkOption {
        type = types.str;
        description = ''
          Password for Mattermost database user.
        '';
      };

      databaseHost = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Mattermost database host.
        '';
      };

      databasePort = mkOption {
        type = types.int;
        default = 5432;
        description = ''
          Mattermost database port.
        '';
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

      matterircd = {
        enable = mkEnableOption "Mattermost IRC bridge";
        package = mkOption {
          type = types.package;
          default = pkgs.matterircd;
          defaultText = "pkgs.matterircd";
          description = "matterircd derivation to use.";
        };
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

      services.postgresql.enable = cfg.databaseCreate;

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
        '' + lib.optionalString cfg.databaseCreate (createDb {}) + ''
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
        };
        unitConfig.JoinsNamespaceOf = mkIf cfg.databaseCreate "postgresql.service";
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
