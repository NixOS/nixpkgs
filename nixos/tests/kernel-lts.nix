import ./make-test.nix ({ pkgs, ...} : {
  name = "kernel-lts";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages;
    };

  testScript =
    ''
      $machine->succeed("uname -s | grep 'Linux'");
      $machine->succeed("uname -a | grep '${pkgs.linuxPackages.kernel.version}'");
    '';
})
