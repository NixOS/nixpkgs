{
  lib,
  ...
}:
let
  mainPort = 4242;
in
{
  name = "rnsd";
  meta.maintainers = [ lib.maintainers.drupol ];

  nodes.machine = {
    services.rnsd = {
      enable = true;
      settings = {
        reticulum = {
          enable_transport = "Yes";
          share_instance = "Yes";
          instance_name = "default";
          discover_interfaces = "No";
          panic_on_interface_error = "No";
        };
        logging = {
          loglevel = 5;
        };
        interfaces = {
          test = {
            type = "BackboneInterface";
            enabled = "yes";
            discoverable = "yes";
            listen_ip = "0.0.0.0";
            listen_port = mainPort;
            discovery_name = "Apollo RNS";
          };
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("Test rnsd service"):
      machine.wait_for_unit("rnsd.service")
      machine.wait_for_open_port(${toString mainPort})
  '';
}
