import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "stratis";

    meta = with pkgs.lib.maintainers; {
      maintainers = [ nickcao ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        services.stratis.enable = true;
        virtualisation.emptyDiskImages = [
          2048
          1024
          1024
          1024
        ];
      };

    testScript = ''
      machine.wait_for_unit("stratisd")
      # test pool creation
      machine.succeed("stratis pool create     testpool /dev/vdb")
      machine.succeed("stratis pool add-data   testpool /dev/vdc")
      machine.succeed("stratis pool init-cache testpool /dev/vdd")
      machine.succeed("stratis pool add-cache  testpool /dev/vde")
      # test filesystem creation and rename
      machine.succeed("stratis filesystem create testpool testfs0")
      machine.succeed("stratis filesystem rename testpool testfs0 testfs1")
      # test snapshot
      machine.succeed("mkdir -p /mnt/testfs1 /mnt/testfs2")
      machine.wait_for_file("/dev/stratis/testpool/testfs1")
      machine.succeed("mount /dev/stratis/testpool/testfs1 /mnt/testfs1")
      machine.succeed("echo test0 > /mnt/testfs1/test0")
      machine.succeed("echo test1 > /mnt/testfs1/test1")
      machine.succeed("stratis filesystem snapshot testpool testfs1 testfs2")
      machine.succeed("echo test2 > /mnt/testfs1/test1")
      machine.wait_for_file("/dev/stratis/testpool/testfs2")
      machine.succeed("mount /dev/stratis/testpool/testfs2 /mnt/testfs2")
      assert "test0" in machine.succeed("cat /mnt/testfs1/test0")
      assert "test0" in machine.succeed("cat /mnt/testfs2/test0")
      assert "test2" in machine.succeed("cat /mnt/testfs1/test1")
      assert "test1" in machine.succeed("cat /mnt/testfs2/test1")
    '';
  }
)
