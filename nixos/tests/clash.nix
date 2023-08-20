import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "clash";
  meta.maintainers = with pkgs.lib.maintainers; [ kaleocheng ];

  nodes.machine = { ... }: {
    services.clash = {
      enable = true;
      settings = {
        mixed-port = 7890;
        external-controller = "127.0.0.1:9090";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("clash.service")
    machine.wait_for_open_port(9090)
    assert machine.succeed("curl --fail http://localhost:9090") == '{"hello":"clash"}'
  '';
}
