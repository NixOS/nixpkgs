import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "discourse";
  meta.maintainers = with lib.maintainers; [ sorki ];

  machine =
    { ... }:
    {
      virtualisation.memorySize = 1024;
      virtualisation.diskSize = 2 * 1024;
      services.discourse = {
        enable = true;
        hostName = "localhost";
        database = {
          name = "discourse";
          createLocally = true;
        };
        web = {
          enable = true;
          https = false;
          workers = 1;
        };
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("discourse.service")

    machine.sleep(60)

    assert "Discourse Setup" in machine.succeed("curl -v -L http://localhost/")
  '';
})
