import ./make-test-python.nix ({ pkgs, ...} : {
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
      assert "Linux" in machine.succeed("uname -s")
      assert "${pkgs.linuxPackages_testing.kernel.modDirVersion}" in machine.succeed("uname -a")
    '';
})
