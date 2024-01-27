{
  name = "Test that basic tests work when busybox is installed";

  nodes = {
    machine = ({ pkgs, ... }: {
      environment.systemPackages = [
        pkgs.busybox
      ];
    });
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
  '';
}
