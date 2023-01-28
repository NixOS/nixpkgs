{ system, pkgs }:

with import ../lib/testing-python.nix { inherit system pkgs; };
let testStoreSharing = { useBootLoader, initrdSystemd }: makeTest  {
  name = "vm";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ brprice ];
  };

  nodes.machine =
    { pkgs, lib, ... }:
    {
      imports = [ ../modules/virtualisation/qemu-vm.nix ];
      virtualisation.useBootLoader = useBootLoader;
      boot.initrd.systemd.enable = initrdSystemd;
    };

  testScript = ''
      machine.wait_for_unit("multi-user.target")

      with subtest("current-system roots"):
          machine.succeed("nix-store --query /run/current-system --roots | grep -q -F '/run/current-system'")

      with subtest("all roots"):
          machine.succeed("test $(nix-store --gc --print-roots | wc -l) -ge 1")

      with subtest("dump db"):
          machine.succeed("test $(nix-store --dump-db | wc -l) -ge 1")
  '';
};
in
{
  noBootLoader = testStoreSharing {useBootLoader = false; initrdSystemd = false;};
  withBootLoader = testStoreSharing {useBootLoader = true; initrdSystemd = false;};
  noBootLoaderInitrdSystemd = testStoreSharing {useBootLoader = false; initrdSystemd = true;};
  withBootLoaderInitrdSystemd = testStoreSharing {useBootLoader = true; initrdSystemd = true;};
}
