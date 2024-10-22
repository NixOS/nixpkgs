{
  name = "Test that sleep of 6 seconds fails a timeout of 5 seconds";
  globalTimeout = 5;

  nodes = {
    machine = ({ pkgs, ... }: {
    });
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("sleep 6")
  '';
}
