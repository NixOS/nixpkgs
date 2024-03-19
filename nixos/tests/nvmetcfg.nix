import ./make-test-python.nix ({ lib, ... }: {
  name = "nvmetcfg";

  meta = {
    maintainers = with lib.maintainers; [ nickcao ];
  };

  nodes = {
    server = { pkgs, ... }: {
      boot.kernelModules = [ "nvmet" ];
      environment.systemPackages = [ pkgs.nvmetcfg ];
      networking.firewall.allowedTCPPorts = [ 4420 ];
      virtualisation.emptyDiskImages = [ 512 ];
    };
    client = { pkgs, ... }: {
      boot.kernelModules = [ "nvme-fabrics" ];
      environment.systemPackages = [ pkgs.nvme-cli ];
    };
  };

  testScript = let subsystem = "nqn.2014-08.org.nixos:server"; in ''
    import json

    with subtest("Create subsystem and namespace"):
      server.succeed("nvmet subsystem add ${subsystem}")
      server.succeed("nvmet namespace add ${subsystem} 1 /dev/vdb")

    with subtest("Bind subsystem to port"):
      server.wait_for_unit("network-online.target")
      server.succeed("nvmet port add 1 tcp 0.0.0.0:4420")
      server.succeed("nvmet port add-subsystem 1 ${subsystem}")

    with subtest("Discover and connect to available subsystems"):
      client.wait_for_unit("network-online.target")
      assert "subnqn:  ${subsystem}" in client.succeed("nvme discover --transport=tcp --traddr=server --trsvcid=4420")
      client.succeed("nvme connect-all --transport=tcp --traddr=server --trsvcid=4420")

    with subtest("Write to the connected subsystem"):
      devices = json.loads(client.succeed("lsblk --nvme --paths --json"))["blockdevices"]
      assert len(devices) == 1
      client.succeed(f"dd if=/dev/zero of={devices[0]['name']} bs=1M count=64")
  '';
})
