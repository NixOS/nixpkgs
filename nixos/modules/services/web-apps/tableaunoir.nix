{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tableaunoir;
  package = pkgs.tableaunoir.override {
    inherit (cfg) settings;
    buildElectronApp = false;
    buildWebsocketServer = cfg.wsServer.enable;
    socketAddr =
      if !(builtins.isNull cfg.wsServer.port) then
        { inherit (cfg.wsServer) port; }
      else
        "/run/tableaunoir/ws.sock";
  };
in
{
  options.services.tableaunoir = {
    enable = lib.mkEnableOption "Serve tableaunoir application";
    wsServer = {
      enable = lib.mkEnableOption "Server the websocket server";
      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = "Port for the websocket server, uses unix socket if null";
      };
      nginxVhost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          If set to non-null, will configure this nginx virtualhost for
          proxying the websocket traffic to the tableaunoir ws server
        '';
        default = null;
      };
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Settings to add to the config.json file before building the app";
      default = { };
    };
    frontendNginxVhost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        If set to non-null, will configure this nginx virtualhost for
        serving the frontend of tableaunoir
      '';
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tableaunoir-ws = lib.mkIf cfg.wsServer.enable {
      description = "Tableaunoir websocket server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = [ "network.target" ];
      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "tableaunoir";
      };
      script = ''
        ${package}/ws-server/tableaunoir-ws
      '';
    };

    services.nginx.virtualHosts = lib.mkMerge [
      (lib.mkIf (!builtins.isNull cfg.frontendNginxVhost) {
        ${cfg.frontendNginxVhost} = {
          root = toString package;
          locations."/" = {
            tryFiles = "$uri $uri/ =404";
          };
          locations."/ws-server" = {
            return = "404";
          };
        };
      })
      (lib.mkIf (!builtins.isNull cfg.wsServer.nginxVhost) {
        ${cfg.wsServer.nginxVhost} = {
          locations."/" = {
            proxyPass =
              if builtins.isNull cfg.wsServer.port then
                "http://unix:/run/tableaunoir/ws.sock:/"
              else
                "http://127.0.0.1:${toString cfg.wsServer.port}";
            proxyWebsockets = true;
          };
        };
      })
    ];
  };
}
