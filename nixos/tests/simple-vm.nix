{
  name = "simple-vm";

  nodes.machine.environment.defaultPackages = [
    # Temporary workaround for #263295/#263289
  ];

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.shutdown()
  '';
}
