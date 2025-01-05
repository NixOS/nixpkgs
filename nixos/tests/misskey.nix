import ./make-test-python.nix (
  { lib, ... }:
  let
    port = 61812;
  in
  {
    name = "misskey";

    meta.maintainers = [ lib.maintainers.feathecutie ];

    nodes.machine = {
      services.misskey = {
        enable = true;
        settings = {
          url = "http://misskey.local";
          inherit port;
        };
        database.createLocally = true;
        redis.createLocally = true;
      };
    };

    testScript = ''
      machine.wait_for_unit("misskey.service")
      machine.wait_for_open_port(${toString port})
      machine.succeed("curl --fail http://localhost:${toString port}/")
    '';
  }
)
