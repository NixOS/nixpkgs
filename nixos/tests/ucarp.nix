import ./make-test-python.nix ({ pkgs, lib, ...} :

let
  addrShared = "192.168.0.1";
  addrHostA = "192.168.0.10";
  addrHostB = "192.168.0.11";

  mkUcarpHost = addr: { config, pkgs, lib, ... }: {
    networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
      { address = addr; prefixLength = 24; }
    ];

    networking.ucarp = {
      enable = true;
      interface = "eth1";
      srcIp = addr;
      vhId = 1;
      passwordFile = "${pkgs.writeText "ucarp-pass" "secure"}";
      addr = addrShared;
      upscript = pkgs.writeScript "upscript" ''
        #!/bin/sh
        ${pkgs.iproute2}/bin/ip addr add "$2"/24 dev "$1"
      '';
      downscript = pkgs.writeScript "downscript" ''
        #!/bin/sh
        ${pkgs.iproute2}/bin/ip addr del "$2"/24 dev "$1"
      '';
    };
  };
in {
  name = "ucarp";
  meta.maintainers = with lib.maintainers; [ oxzi ];

  nodes = {
    hostA = mkUcarpHost addrHostA;
    hostB = mkUcarpHost addrHostB;
  };

  testScript = ''
    def is_master(host):
      ipOutput = host.succeed("ip addr show dev eth1")
      return "inet ${addrShared}/24" in ipOutput


    start_all()

    # First, let both hosts start and let a master node be selected
    for host, peer in [(hostA, "${addrHostB}"), (hostB, "${addrHostA}")]:
      host.wait_for_unit("ucarp.service")
      host.succeed(f"ping -c 1 {peer}")

    hostA.sleep(5)

    hostA_master, hostB_master = is_master(hostA), is_master(hostB)
    assert hostA_master != hostB_master, "only one master node is allowed"

    master_host = hostA if hostA_master else hostB
    backup_host = hostB if hostA_master else hostA

    # Let's crash the master host and let the backup take over
    master_host.crash()

    backup_host.sleep(5)
    assert is_master(backup_host), "backup did not take over"
  '';
})
