{ lib, ... }:
{
  name = "umami-nixos";

  meta.maintainers = with lib.maintainers; [ diogotcorreia ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.umami = {
        enable = true;
        settings = {
          APP_SECRET = "very_secret";
        };
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("umami.service")

    machine.wait_for_open_port(3000)
    machine.succeed("curl --fail http://localhost:3000/")
    machine.succeed("curl --fail http://localhost:3000/script.js")

    res = machine.succeed("""
      curl -f --json '{ "username": "admin", "password": "umami" }' http://localhost:3000/api/auth/login
    """)
    token = json.loads(res)['token']

    res = machine.succeed("""
      curl -f -H 'Authorization: Bearer %s' --json '{ "domain": "localhost", "name": "Test" }' http://localhost:3000/api/websites
    """ % token)
    print(res)
    websiteId = json.loads(res)['id']

    res = machine.succeed("""
      curl -f -H 'Authorization: Bearer %s' http://localhost:3000/api/websites/%s
    """ % (token, websiteId))
    website = json.loads(res)
    assert website["name"] == "Test"
    assert website["domain"] == "localhost"
  '';
}
