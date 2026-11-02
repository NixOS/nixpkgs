{ lib, ... }:

{
  name = "ersatztv";
  meta.maintainers = with lib.maintainers; [ allout58 ];

  nodes.basic =
    { ... }:
    {
      services.ersatztv.enable = true;
    };
  nodes.reconfigured =
    { ... }:
    {
      services.ersatztv.enable = true;
      services.ersatztv.environment.ETV_UI_PORT = 8123;
      services.ersatztv.openFirewall = true;
    };

  # ErsatzTV doesn't really have an API to speak of currently, so just check if it responds at all
  testScript =
    { nodes, ... }:
    let
      basicIp = (lib.head nodes.basic.networking.interfaces.eth1.ipv4.addresses).address;
      reconfiguredIp = (lib.head nodes.reconfigured.networking.interfaces.eth1.ipv4.addresses).address;
    in
    ''
      start_all()
      basic.wait_for_unit("ersatztv.service")
      basic.wait_for_open_port(8409)
      basic.succeed("curl --fail http://localhost:8409/api/sessions")

      reconfigured.wait_for_unit("ersatztv.service")
      reconfigured.wait_for_open_port(8123)
      reconfigured.succeed("curl --fail http://localhost:8123/api/sessions")

      # Test that the firewall is open
      reconfigured.fail("curl --fail --connect-timeout 5 http://${basicIp}:8409/api/sessions")
      basic.succeed("curl --fail http://${reconfiguredIp}:8123/api/sessions")
    '';
}
