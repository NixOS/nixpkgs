import ./make-test-python.nix (
  let
    password = "much-secure-so-password";
  in
  { lib, ... }:
  {
    name = "fusion";
    meta.maintainers = with lib.maintainers; [ pluiedev ];

    nodes.machine =
      { pkgs, ... }:
      {
        networking.firewall.enable = false;
        networking.useDHCP = false;

        services.fusion = {
          enable = true;

          # WARNING: Never EVER do this in production.
          passwordFile = pkgs.writeText "fusion-test-password" password;
        };
      };

    testScript = ''
      machine.wait_for_unit("network-online.target")
      machine.wait_for_open_port(8080)

      # Try logging in
      machine.succeed('curl -X POST -H "Content-Type: application/json" --data \'{"password":"${password}"}\' 127.0.0.1:8080/api/sessions')
      machine.wait_for_console_text('"status":201')
    '';
  }
)
