{ lib, pkgs, ... }:

{
  name = "ersatztv";
  meta.maintainers = with lib.maintainers; [ allout58 ];

  nodes.basic =
    { ... }:
    {
      services.ersatztv.enable = true;
      environment.systemPackages = [ pkgs.jq ];
    };
  nodes.reconfigured =
    { ... }:
    {
      services.ersatztv.enable = true;
      services.ersatztv.environment.ETV_UI_PORT = 8123;
      services.ersatztv.openFirewall = true;
      environment.systemPackages = [ pkgs.jq ];
    };

  # ErsatzTV doesn't really have an API to speak of currently, so just check if it responds at all
  testScript =
    { nodes, ... }:
    let
      basicIp = (lib.head nodes.basic.networking.interfaces.eth1.ipv4.addresses).address;
      reconfiguredIp = (lib.head nodes.reconfigured.networking.interfaces.eth1.ipv4.addresses).address;
    in
    ''
      def api_key(machine):
          return machine.wait_until_succeeds(
              "jq -er .ApiKey /var/lib/ersatztv/config/api-secrets.json"
          ).strip()

      def api_get(url, key):
          return f"curl --fail -H 'X-Etv-Api-Key: {key}' {url}"

      start_all()
      basic.wait_for_unit("ersatztv.service")
      basic.wait_for_open_port(8409)
      basic_key = api_key(basic)
      basic.succeed(api_get("http://localhost:8409/api/sessions", basic_key))

      reconfigured.wait_for_unit("ersatztv.service")
      reconfigured.wait_for_open_port(8123)
      reconfigured_key = api_key(reconfigured)
      reconfigured.succeed(api_get("http://localhost:8123/api/sessions", reconfigured_key))

      # Test that the firewall is open
      reconfigured.fail(
          api_get("--connect-timeout 5 http://${basicIp}:8409/api/sessions", basic_key)
      )
      basic.succeed(api_get("http://${reconfiguredIp}:8123/api/sessions", reconfigured_key))
    '';
}
