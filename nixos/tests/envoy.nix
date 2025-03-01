import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "envoy";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ cameronnemo ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        services.envoy.enable = true;
        services.envoy.settings = {
          admin = {
            access_log_path = "/dev/null";
            address = {
              socket_address = {
                protocol = "TCP";
                address = "127.0.0.1";
                port_value = 80;
              };
            };
          };
          static_resources = {
            listeners = [ ];
            clusters = [ ];
          };
        };
        specialisation = {
          withoutConfigValidation.configuration =
            { ... }:
            {
              services.envoy = {
                requireValidConfig = false;
                settings.admin.access_log_path = lib.mkForce "/var/log/envoy/access.log";
              };
            };
        };
      };

    testScript =
      { nodes, ... }:
      let
        specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
      in
      ''
        machine.start()

        with subtest("envoy.service starts and responds with ready"):
          machine.wait_for_unit("envoy.service")
          machine.wait_for_open_port(80)
          machine.wait_until_succeeds("curl -fsS localhost:80/ready")

        with subtest("envoy.service works with config path not available at eval time"):
          machine.succeed('${specialisations}/withoutConfigValidation/bin/switch-to-configuration test')
          machine.wait_for_unit("envoy.service")
          machine.wait_for_open_port(80)
          machine.wait_until_succeeds("curl -fsS localhost:80/ready")
          machine.succeed('test -f /var/log/envoy/access.log')
      '';
  }
)
