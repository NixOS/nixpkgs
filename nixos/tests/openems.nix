{ pkgs, ... }:
let
  edge_felix_port = 1234;
  edge_ui_port = 1235;
  backend_felix_port = 1234;
  backend_ui_port = 1235;
  backend_edge_port = 1236;

in
{
  name = "openems";
  meta.maintainers = with pkgs.lib.maintainers; [ mrcjkb ];
  nodes = {
    edge =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          # For testing
          pkgs.websocat
        ];

        services.openems.edge = {
          enable = true;
          ui = {
            enable = true;
            port = edge_ui_port;
          };
          felix.port = edge_felix_port;
          watchdog.timeout = null; # watchdog can make the tests flaky
        };
      };
    backend =
      { pkgs, ... }:
      {
        services.openems = {
          backend = {
            enable = true;
            ui.port = backend_ui_port;
            edgeManager = {
              port = backend_edge_port;
              openFirewall = true;
            };
            felix.port = backend_felix_port;
            watchdog.timeout = null; # watchdog can make the tests flaky
          };
        };
      };
  };

  testScript = /* python */ ''
    backend.wait_for_unit("openems-backend.service")
    backend.wait_for_open_port(${toString backend_felix_port})
    backend.wait_until_succeeds("curl -u admin:admin --fail http://localhost:${toString backend_felix_port}/system/console/configMgr")

    config_json = backend.succeed("curl -u admin:admin http://localhost:${toString backend_felix_port}/system/console/status-Configurations.json")
    assert "port = ${toString backend_edge_port}" in config_json
    assert "port = ${toString backend_ui_port}" in config_json

    # Configure authentication service provider for edge nodes
    backend.succeed("curl --verbose -u admin:admin --fail -d 'apply=true' -d 'pid=Metadata.Dummy' -d 'propertylist=edgeIdMax,edgeIdTemplate' -d 'edgeIdMax=1' -d 'edgeIdTemplate=edge%25d' http://localhost:${toString backend_felix_port}/system/console/configMgr/Metadata.Dummy")

    backend.wait_for_console_text("\[Edge\.Manager\] Starting websocket server")

    edge.wait_for_unit("openems-edge.service")
    edge.wait_for_console_text("\[ctrlApiWebsocket0\] Starting websocket server")
    edge.wait_for_console_text("There are no Schedulers configured!") # The node is ready - this gets printed repeatedly
    edge.succeed("echo | websocat --origin 'http://localhost' 'ws://localhost:${toString edge_ui_port}'")
    edge.wait_for_open_port(${toString edge_felix_port})
    edge.wait_until_succeeds("curl --user admin:admin --fail http://localhost:${toString edge_felix_port}/system/console/configMgr")

    # Configure edge-backend connection
    edge.succeed("curl --verbose -u admin:admin --fail -d 'apply=true' -d 'factoryPid=Controller.Api.Backend' -d 'propertylist=id,uri,apikey,enabled' -d 'id=ctrlBackend0' -d 'uri=ws://backend:${toString backend_edge_port}' -d 'apikey=DEMO_API_KEY' -d 'enabled=true' http://localhost:${toString edge_felix_port}/system/console/configMgr/Controller.Api.Backend")
    edge.wait_for_console_text("Connected to OpenEMS Backend")
  '';
}
