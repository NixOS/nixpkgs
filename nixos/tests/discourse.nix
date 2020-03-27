import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "discourse";
  meta.maintainers = with lib.maintainers; [ sorki ];

  machine =
    { ... }:
    {
      virtualisation.memorySize = 1024;
      virtualisation.diskSize = 2 * 1024;

      # discourse doesn't like when mail domain is localhost
      networking.extraHosts = ''
        127.0.0.1 discourse.xmpl
      '';

      services.discourse = {
        enable = true;
        hostName = "discourse.xmpl";
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
    machine.wait_for_open_port("3000")
    assert "Discourse Setup" in machine.succeed("curl -v -L http://discourse.xmpl/")
  '';
})
