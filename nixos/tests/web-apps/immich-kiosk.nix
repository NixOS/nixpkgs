{ ... }:
{
  name = "immich-kiosk";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];

      services.immich-kiosk = {
        enable = true;
        settings = {
          immich_url = "http://localhost:2283";
          immich_api_key = {
            _secret = pkgs.writeText "immich-kiosk-api-key" "dummy-api-key";
          };
          kiosk = {
            port = 3100;
            demo_mode = true;
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("immich-kiosk.service")
    machine.wait_for_open_port(3100)
    machine.succeed("pgrep -x immich-kiosk")
    machine.succeed("jq -r .immich_api_key /run/immich-kiosk/config.yaml | grep dummy-api-key")
  '';
}
