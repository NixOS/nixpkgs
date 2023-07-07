{
  name = "Test for NixOS/nixpkgs#241938";

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
