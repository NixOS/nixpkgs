{ lib, ... }:
{
  name = "tenstorrent";

  nodes = {
    default = {
      hardware.tenstorrent.enable = true;
    };

    configured = {
      hardware.tenstorrent = {
        enable = true;
        hugepages.count = 8;
        iommuPassthrough = true;
      };
    };

    nohugepages = {
      hardware.tenstorrent = {
        enable = true;
        hugepages.enable = false;
      };
    };
  };

  # no card in the VM, so this checks that the module boots cleanly and the
  # hugepage setup is a no-op, not that a card is configured
  testScript = ''
    start_all()

    with subtest("driver loads and tools are installed"):
        default.wait_for_unit("multi-user.target")
        default.succeed("lsmod | grep -q '^tenstorrent'")
        default.succeed("command -v tt-smi")

    with subtest("hugepage setup succeeds without a card"):
        default.succeed("systemctl is-active tenstorrent-hugepages.service")
        default.succeed("journalctl -u tenstorrent-hugepages.service | grep -q 'Completed hugepage setup'")
        default.fail("systemctl show -p Environment tenstorrent-hugepages.service | grep -q TT_HUGEPAGES_OVERRIDE_FILE")

    with subtest("hugetlbfs is mounted at /dev/hugepages-1G"):
        default.succeed("test -d /sys/kernel/mm/hugepages/hugepages-1048576kB")
        default.succeed("findmnt -t hugetlbfs -o OPTIONS /dev/hugepages-1G | grep -q pagesize=1024M")

    with subtest("count writes the override and iommuPassthrough sets the parameter"):
        configured.wait_for_unit("multi-user.target")
        configured.succeed(
            "grep -qx 8 $(systemctl show -p Environment --value tenstorrent-hugepages.service"
            " | tr ' ' '\\n' | sed -n 's/^TT_HUGEPAGES_OVERRIDE_FILE=//p')"
        )
        configured.succeed("systemctl is-active tenstorrent-hugepages.service")
        configured.succeed("journalctl -u tenstorrent-hugepages.service | grep -q 'override requested'")
        configured.succeed("grep -qw iommu=pt /proc/cmdline")
        default.fail("grep -qw iommu=pt /proc/cmdline")

    with subtest("hugepages can be disabled"):
        nohugepages.wait_for_unit("multi-user.target")
        nohugepages.fail("systemctl cat tenstorrent-hugepages.service")
        nohugepages.fail("mountpoint -q /dev/hugepages-1G")
  '';

  meta.maintainers = with lib.maintainers; [ RossComputerGuy ];
}
