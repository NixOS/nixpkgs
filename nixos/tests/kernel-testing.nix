import ./make-test.nix ({ pkgs, ...} : {
  name = "kernel-testing";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_testing;
    };

  testScript =
    ''
      $machine->succeed("uname -s | grep 'Linux'");
      $machine->succeed("uname -a | grep '${pkgs.linuxPackages_testing.kernel.modDirVersion}'");
    '';
})
