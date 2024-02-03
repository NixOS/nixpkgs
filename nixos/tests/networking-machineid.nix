import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "networking-machineid";

  meta.maintainers = [ pkgs.lib.maintainers.eyjhb ];

  nodes.machine.networking.machineId = "7d3a942d3709b36857a06affc5019ba2";

  testScript = { nodes, ... }:
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      assert "${nodes.machine.networking.machineId}\n" == machine.succeed("cat /etc/machine-id")
      assert "d086d05f\n" == machine.succeed("cat /etc/hostid | ${pkgs.xxd}/bin/xxd -p")
    '';
})
