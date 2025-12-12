{
  name = "simple";

  nodes.machine = { };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.shutdown()
  '';
}
