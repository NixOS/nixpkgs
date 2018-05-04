import ./make-test.nix ({ pkgs, ...} : {
  name = "kernel-signed-modules";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ symphorien ];
  };

  machine = { config, pkgs, ... }: {
    boot.initrd.kernelModules = ["zram"];
    security.enforceModuleSignature = true;
    environment.systemPackages = [ pkgs.kmod pkgs.tree pkgs.xz pkgs.binutils ];
  };

  testScript = ''
    # check that modules copied to the initrd work
    print $machine->succeed("lsmod");
    print $machine->succeed("lsmod | grep zram");
    # check we can load modules now
    print $machine->succeed("modprobe bonding");
    # check we cannot load an unsigned module
    print $machine->succeed("cp /run/current-system/kernel-modules/lib/modules/*/kernel/block/bfq.ko.xz /tmp && unxz /tmp/bfq.ko.xz && strip --strip-debug /tmp/bfq.ko");
    print $machine->fail("insmod /tmp/bfq.ko");
  '';
})
