{ lib, ... }:

{
  name = "polaris";
  meta.maintainers = with lib.maintainers; [ pbsds ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];
      services.polaris = {
        enable = true;
        port = 5050;
        settings.users = [
          {
            name = "test_user";
            password = "very_secret_password";
            admin = true;
          }
        ];
      };
    };

  testScript = ''
    machine.wait_for_unit("polaris.service")
    machine.wait_for_open_port(5050)
    machine.succeed("curl http://localhost:5050/api/version")
    machine.succeed("curl -X GET http://localhost:5050/api/initial_setup -H  'accept: application/json' | jq -e '.has_any_users == true'")
  '';
}
