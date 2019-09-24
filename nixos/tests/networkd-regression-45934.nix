import ./make-test.nix ({ pkgs, lib, ...} : {
  machine = { ... }: {
    networking.dhcpcd.enable = false;
    systemd.network.enable = true;
  };
  testScript = ''
    $machine->waitForUnit("default.target");
    $machine->succeed("ip link add ve-lol type veth");
    $machine->succeed("ip link add vz-lol type veth");
    $machine->waitUntilSucceeds("networkctl status vz-lol | grep ${pkgs.systemd}/lib/systemd/network/80-container-ve.network");
    $machine->waitUntilSucceeds("networkctl status vz-lol | grep ${pkgs.systemd}/lib/systemd/network/80-container-vz.network");
  '';
})
