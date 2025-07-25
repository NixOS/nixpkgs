{
  name = "Test that testinfra works";

  nodes = {
    machine = ({ pkgs, ... }: { });
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    assert machine.user('root').exists

    passwd = machine.file("/etc/passwd")
    assert passwd.exists
    assert passwd.is_file

    cmd = machine.run("echo hello")
    assert cmd.rc == 0
    assert cmd.stdout.strip() == 'hello'

    service = machine.service("multi-user.target")
    assert service.exists
    assert service.systemd_properties['Before'] == "shutdown.target", "Before property is not set correctly"
  '';
}
