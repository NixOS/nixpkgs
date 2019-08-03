import ./make-test.nix ({ pkgs, ...} : {
  name = "kernel-latest";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };

  testScript =
    ''
      $machine->succeed("uname -s | grep 'Linux'");
      $machine->succeed("uname -a | grep '${pkgs.linuxPackages_latest.kernel.version}'");
    '';
})
