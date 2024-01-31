import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "pingvin-share";
  meta.maintainers = with lib.maintainers; [ ratcornu ];

  nodes.machine = { pkgs, ... }: {
    services.pingvin-share = {
      enable = true;

      backend.port = 9010;
      frontend.port = 9011;
    };
  };

  testScript = ''
    machine.wait_for_unit("pingvin-share-frontend.service")
    machine.wait_for_open_port(9011)
    machine.succeed("curl --fail http://127.0.0.1:9010/")
    machine.succeed("curl --fail http://127.0.0.1:9011/")
  '';
})
