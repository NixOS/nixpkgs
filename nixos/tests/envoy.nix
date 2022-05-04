import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "envoy";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ cameronnemo ];
  };

  nodes.machine = { pkgs, ... }: {
    services.envoy.enable = true;
    services.envoy.settings = {
      admin = {
        access_log_path = "/dev/null";
        address = {
          socket_address = {
            protocol = "TCP";
            address = "127.0.0.1";
            port_value = 9901;
          };
        };
      };
      static_resources = {
        listeners = [];
        clusters = [];
      };
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("envoy.service")
    machine.wait_for_open_port(9901)
    machine.wait_until_succeeds("curl -fsS localhost:9901/ready")
  '';
})
