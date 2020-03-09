{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gerrit;

  cmd = "${pkgs.jre_headless}/bin/java -jar ${cfg.package}/webapps/gerrit-${cfg.package.version}.war";

  mkPluginSectionName = plugin: ''plugin "${escape [ "\"" ] plugin}"'';

  settingsFile = pkgs.writeText "gerrit.config" ''
    ${generators.toINI {} cfg.settings}
    ${generators.toINI { mkSectionName = mkPluginSectionName; } cfg.pluginSettings}
  '';

  pluginDir = pkgs.runCommandNoCC "gerrit-plugins"
    { inherit (cfg) plugins; }
    ''
      mkdir $out
      cd $out
      for plugin in $plugins; do
        ln -sv $plugin
      done
    '';

in

{

  options = {

    services.gerrit = {

      enable = mkEnableOption "Gerrit Code Review";

      package = mkOption {
        type = types.package;
        default = pkgs.gerrit;
        defaultText = "pkgs.gerrit";
        description = ''
          The package used for the Gerrit daemon.
        '';
      };

      settings = mkOption {
        type = with types; lazyAttrsOf (lazyAttrsOf str);
        default = {};
      };

      basePath = mkOption {
        type = types.str;
        default = "git";
        description = ''
          Local filesystem directory holding all Git repositories that Gerrit
          knows about and can process changes for. A project entity in Gerrit
          maps to a local Git repository by creating the path string
          "''${basePath}/''${project_name}.git".

          If relative, the path is resolved relative to /var/lib/gerrit.
        '';
      };

      canonicalWebUrl = mkOption {
        type = types.str;
        description = ''
          The default URL for Gerrit to be accessed through.
          Typically this would be set to something like
          "http://review.example.com/" or "http://example.com:8080/gerrit/" so
          Gerrit can output links that point back to itself.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0:80";
      };

      plugins = mkOption {
        type = with types; listOf path;
        default = [];
      };

      pluginSettings = mkOption {
        type = with types; lazyAttrsOf (lazyAttrsOf str);
        default = {};
      };

    };

  };

  config = mkIf cfg.enable {

    services.gerrit.settings = {
      gerrit = {
        inherit (cfg) basePath canonicalWebUrl;
      };
      httpd.inheritChannel = true;
      # TODO(edef): support SSH properly
      sshd.listenAddress = "off";
      cache.directory = "/var/cache/gerrit";
    };

    users.users.gerrit = {};

    systemd.sockets.gerrit = {
      unitConfig.Description = "Gerrit HTTP socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ cfg.listenAddress ];
    };

    systemd.services.gerrit = {
      unitConfig.Description = "Gerrit Code Review";
      wantedBy = [ "multi-user.target" ];
      requires = [ "gerrit.socket" ];
      after = [ "gerrit.socket" "network.target" ];

      serviceConfig.Type = "simple";
      serviceConfig.StandardInput = "socket";
      serviceConfig.StandardOutput = "journal";

      serviceConfig.User = "gerrit";
      serviceConfig.CacheDirectory = "gerrit";
      serviceConfig.StateDirectory = "gerrit";
      serviceConfig.WorkingDirectory = "%S/gerrit";

      environment.GERRIT_TMP = "%T";
      serviceConfig.PrivateTmp = true;

      preStart = ''
        set -euo pipefail

        if ! [ -f server-id ]; then
          ${pkgs.utillinux}/bin/uuidgen > server-id.tmp
          mv server-id.tmp server-id
        fi

        mkdir -p etc
        cat - ${settingsFile} <<EOF > etc/gerrit.config
        [gerrit]
        serverId=$(cat server-id)
        EOF

        if [ "$(readlink -f plugins)" != ${pluginDir} ]; then
          rm -f plugins
          ln -s ${pluginDir} plugins
        fi
      '';

      serviceConfig.ExecStart = "${cmd} daemon --init --console-log";
    };

  };

}
