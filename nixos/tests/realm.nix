import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "realm";

  meta = {
    maintainers = with lib.maintainers; [ ocfox ];
  };

  nodes.machine = { pkgs, ... }: {
    services.nginx = {
      enable = true;
      statusPage = true;
    };
    # realm need DNS resolv server to run or use config.dns.nameserver
    services.resolved.enable = true;

    services.realm = {
      enable = true;
      config = {
        endpoints = [
          {
            listen = "0.0.0.0:1000";
            remote = "127.0.0.1:80";
          }
        ];
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("realm.service")

    machine.wait_for_open_port(80)
    machine.wait_for_open_port(1000)

    machine.succeed("curl --fail http://localhost:1000/")
  '';

})
