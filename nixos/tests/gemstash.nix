{ runTest, pkgs }:
let
  inherit (pkgs) lib;
in
{
  gemstash_works = runTest {
    name = "gemstash-works";
    meta.maintainers = with lib.maintainers; [ viraptor ];

    nodes.machine = {
      services.gemstash.enable = true;
    };

    # gemstash responds to http requests
    testScript = ''
      machine.wait_for_unit("gemstash.service")
      machine.wait_for_file("/var/lib/gemstash")
      machine.wait_for_open_port(9292)
      machine.succeed("curl http://localhost:9292")
    '';
  };

  gemstash_custom_port = runTest {
    name = "gemstash-custom-port";
    meta.maintainers = with lib.maintainers; [ viraptor ];

    nodes.machine = {
      services.gemstash = {
        enable = true;
        openFirewall = true;
        settings = {
          bind = "tcp://0.0.0.0:12345";
        };
      };
    };

    # gemstash responds to http requests
    testScript = ''
      machine.wait_for_unit("gemstash.service")
      machine.wait_for_file("/var/lib/gemstash")
      machine.wait_for_open_port(12345)
      machine.succeed("curl http://localhost:12345")
    '';
  };
}
