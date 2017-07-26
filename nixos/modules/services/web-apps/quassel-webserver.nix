{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.quassel-webserver;
  quassel-webserver = cfg.pkg;
  settings = ''
    module.exports = {
      default: {
        host: '${cfg.quasselCoreHost}',  // quasselcore host
        port: ${toString cfg.quasselCorePort},  // quasselcore port
        initialBacklogLimit: ${toString cfg.initialBacklogLimit},  // Amount of backlogs to fetch per buffer on connection
        backlogLimit: ${toString cfg.backlogLimit},  // Amount of backlogs to fetch per buffer after first retrieval
        securecore: ${boolToString cfg.secureCore},  // Connect to the core using SSL
        theme: '${cfg.theme}'  // Default UI theme
      },
      themes: ['default', 'darksolarized'],  //  Available themes
      forcedefault: ${boolToString cfg.forceHostAndPort},  // Will force default host and port to be used, and will hide the corresponding fields in the UI
      prefixpath: '${cfg.prefixPath}'  // Configure this if you use a reverse proxy
    };
  '';
  settingsFile = pkgs.writeText "settings-user.js" settings;
in {
  options = {
    services.quassel-webserver = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable the quassel webclient service";
      };
      pkg = mkOption {
        default = pkgs.quassel-webserver;
        defaultText = "pkgs.quassel-webserver";
        type = types.package;
        description = "The quassel-webserver package";
      };
      quasselCoreHost = mkOption {
        default = "";
        type = types.str;
        description = "The default host of the quassel core";
      };
      quasselCorePort = mkOption {
        default = 4242;
        type = types.int;
        description = "The default quassel core port";
      };
      initialBacklogLimit = mkOption {
        default = 20;
        type = types.int;
        description = "Amount of backlogs to fetch per buffer on connection";
      };
      backlogLimit = mkOption {
        default = 100;
        type = types.int;
        description = "Amount of backlogs to fetch per buffer after first retrieval";
      };
      secureCore = mkOption {
        default = true;
        type = types.bool;
        description = "Connect to the core using SSL";
      };
      theme = mkOption {
        default = "default";
        type = types.str;
        description = "default or darksolarized";
      };
      prefixPath = mkOption {
        default = "";
        type = types.str;
        description = "Configure this if you use a reverse proxy. Must start with a '/'";
        example = "/quassel";
      };
      port = mkOption {
        default = 60443;
        type = types.int;
        description = "The port the quassel webserver should listen on";
      };
      useHttps = mkOption {
        default = true;
        type = types.bool;
        description = "Whether the quassel webserver connection should be a https connection";
      };
      forceHostAndPort = mkOption {
        default = false;
        type = types.bool;
        description = "Force the users to use the quasselCoreHost and quasselCorePort defaults";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.quassel-webserver = {
      description = "A web server/client for Quassel";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${quassel-webserver}/lib/node_modules/quassel-webserver/bin/www -p ${toString cfg.port} -m ${if cfg.useHttps == true then "https" else "http"} -c ${settingsFile}";
      };
    };
  };
}
