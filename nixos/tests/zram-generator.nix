import ./make-test-python.nix {
  name = "zram-generator";

  nodes = {
    single = { ... }: {
      virtualisation = {
        emptyDiskImages = [ 512 ];
      };
      zramSwap = {
        enable = true;
        priority = 10;
        algorithm = "lz4";
        swapDevices = 1;
        memoryPercent = 30;
        memoryMax = 10 * 1024 * 1024;
        writebackDevice = "/dev/vdb";
      };
    };
    machine = { ... }: {
      zramSwap = {
        enable = true;
        priority = 10;
        algorithm = "lz4";
        swapDevices = 2;
        memoryPercent = 30;
        memoryMax = 10 * 1024 * 1024;
      };
    };
  };

  testScript = ''
    single.wait_for_unit("systemd-zram-setup@zram0.service")

    machine.wait_for_unit("systemd-zram-setup@zram0.service")
    machine.wait_for_unit("systemd-zram-setup@zram1.service")
    zram = machine.succeed("zramctl --noheadings --raw")
    swap = machine.succeed("swapon --show --noheadings")
    for i in range(2):
        assert f"/dev/zram{i} lz4 10M" in zram
        assert f"/dev/zram{i} partition  10M" in swap
  '';
}
