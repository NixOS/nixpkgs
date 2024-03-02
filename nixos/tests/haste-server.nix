import ./make-test-python.nix ({ pkgs, lib, ... }:
  {
    name = "haste-server";
    meta.maintainers = with lib.maintainers; [ mkg20001 ];

    nodes.machine = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        curl
        jq
      ];

      services.haste-server = {
        enable = true;
      };
    };

    testScript = ''
      machine.wait_for_unit("haste-server")
      machine.wait_until_succeeds("curl -s localhost:7777")
      machine.succeed('curl -s -X POST http://localhost:7777/documents -d "Hello World!" > bla')
      machine.succeed('curl http://localhost:7777/raw/$(cat bla | jq -r .key) | grep "Hello World"')
    '';
  })
