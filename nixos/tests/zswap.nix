{ lib, ... }:
{
  name = "zswap";
  meta.maintainers = with lib.maintainers; [ pigsinablanket ];

  nodes.machine =
    { ... }:
    {
      zswap = {
        enable = true;
        compressor = "zstd";
        zpool = "zsmalloc";
        maxPoolPercent = 25;
        acceptThresholdPercent = 85;
      };

    };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")

    machine.succeed("cat /sys/module/zswap/parameters/enabled | grep Y")
    machine.succeed("cat /sys/module/zswap/parameters/compressor | grep zstd")
    machine.succeed("cat /sys/module/zswap/parameters/zpool | grep zsmalloc")
    machine.succeed("cat /sys/module/zswap/parameters/max_pool_percent | grep 25")
    machine.succeed("cat /sys/module/zswap/parameters/accept_threshold_percent | grep 85")

    machine.succeed("dmesg | grep 'zswap: loaded using pool zstd/zsmalloc'")
  '';
}
