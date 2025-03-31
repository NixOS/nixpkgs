{ ...}: {
  name = "colord";
  nodes.machine = {
    services.colord.enable = true;
  };
  testScript = ''
    machine.wait_for_unit("multi-user.target")
    
    with subtest("colord daemon started"):
          machine.succeed("systemctl status colord.service")
  '';
}
