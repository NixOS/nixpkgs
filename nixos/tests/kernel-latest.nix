import ./make-test-python.nix ({ pkgs, ...} : {
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
      assert "Linux" in machine.succeed("uname -s")
      assert "${pkgs.linuxPackages_latest.kernel.version}" in machine.succeed("uname -a")
    '';
})
