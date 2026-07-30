# Test for NixOS' container nesting.

{ pkgs, ... }:
{
  name = "nested";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ sorki ];
  };

  nodes.machine =
    { lib, ... }:
    let
      makeNested = subConf: {
        containers.nested = {
          autoStart = true;
          privateNetwork = true;
          config = subConf;
        };
      };
    in
    makeNested (makeNested { });

  testScript = ''
    machine.start()
    machine.wait_for_unit("container@nested.service")
    machine.succeed("systemd-run --pty --machine=nested -- machinectl list | grep nested")
    print(
        machine.succeed(
            "systemd-run --pty --machine=nested -- systemd-run --pty --machine=nested -- systemctl status"
        )
    )
  '';
}
