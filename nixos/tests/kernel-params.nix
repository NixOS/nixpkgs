import ./make-test.nix ({ pkgs, ...} : {
  name = "kernel-params";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { config, lib, pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages;
      boot.kernelParams = [
        "nohibernate"
        "page_poison=1"
        "vsyscall=none"
      ];
    };

  testScript =
    ''
      $machine->fail("cat /proc/cmdline | grep page_poison=0");
      $machine->succeed("cat /proc/cmdline | grep nohibernate");
      $machine->succeed("cat /proc/cmdline | grep page_poison=1");
      $machine->succeed("cat /proc/cmdline | grep vsyscall=none");
    '';
})
