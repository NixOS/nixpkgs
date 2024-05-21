{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.shout;
  shoutHome = "/var/lib/shout";

  defaultConfig = pkgs.runCommand "config.js" { preferLocalBuild = true; } ''
    EDITOR=true ${pkgs.shout}/bin/shout config --home $PWD
    mv config.js $out
  '';

  finalConfigFile = if (cfg.configFile != null) then cfg.configFile else ''
    var _ = require('${pkgs.shout}/lib/node_modules/shout/node_modules/lodash')

    module.exports = _.merge(
      {},
      require('${defaultConfig}'),
      ${builtins.toJSON cfg.config}
    )
  '';

in {
  options.services.shout = {
    enable = mkEnableOption "Shout web IRC client";

    private = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make your shout instance private. You will need to configure user
        accounts by adding entries in {file}`${shoutHome}/users`.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "IP interface to listen on for http connections.";
    };

    port = mkOption {
      type = types.port;
      default = 9000;
      description = "TCP port to listen on for http connections.";
    };

    configFile = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Contents of Shout's {file}`config.js` file.

        Used for backward compatibility, recommended way is now to use
        the `config` option.

        Documentation: http://shout-irc.com/docs/server/configuration.html
      '';
    };

    config = mkOption {
      default = {};
      type = types.attrs;
      example = {
        displayNetwork = false;
        defaults = {
          name = "Your Network";
          host = "localhost";
          port = 6697;
        };
      };
      description = ''
        Shout {file}`config.js` contents as attribute set (will be
        converted to JSON to generate the configuration file).

        The options defined here will be merged to the default configuration file.

        Documentation: http://shout-irc.com/docs/server/configuration.html
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.shout = {
      isSystemUser = true;
      group = "shout";
      description = "Shout daemon user";
      home = shoutHome;
      createHome = true;
    };
    users.groups.shout = {};

    systemd.services.shout = {
      description = "Shout web IRC client";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      preStart = "ln -sf ${pkgs.writeText "config.js" finalConfigFile} ${shoutHome}/config.js";
      script = concatStringsSep " " [
        "${pkgs.shout}/bin/shout"
        (if cfg.private then "--private" else "--public")
        "--port" (toString cfg.port)
        "--host" (toString cfg.listenAddress)
        "--home" shoutHome
      ];
      serviceConfig = {
        User = "shout";
        ProtectHome = "true";
        ProtectSystem = "full";
        PrivateTmp = "true";
      };
    };
  };
}
