import ./make-test-python.nix (
  { ... }:
  {
    name = "consul-template";

    nodes.machine =
      { ... }:
      {
        services.consul-template.instances.example.settings = {
          template = [
            {
              contents = ''
                {{ key "example" }}
              '';
              perms = "0600";
              destination = "/example";
            }
          ];
        };

        services.consul = {
          enable = true;
          extraConfig = {
            server = true;
            bootstrap_expect = 1;
            bind_addr = "127.0.0.1";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("consul.service")
      machine.wait_for_open_port(8500)

      machine.wait_for_unit("consul-template-example.service")

      machine.wait_until_succeeds('consul kv put example example')

      machine.wait_for_file("/example")
      machine.succeed('grep "example" /example')
    '';
  }
)
