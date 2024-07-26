import ../make-test-python.nix ({ pkgs, lib, ... } :

{
  name = "incus-socket-activated";

  meta = {
    maintainers = lib.teams.lxc.members;
  };

  nodes.machine = { lib, ... }: {
    virtualisation = {
      incus.enable = true;
      incus.socketActivation = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("incus.socket")

    # ensure service is not running by default
    machine.fail("systemctl is-active incus.service")
    machine.fail("systemctl is-active incus-preseed.service")

    # access the socket and ensure the service starts
    machine.succeed("incus list")
    machine.wait_for_unit("incus.service")
  '';
})
