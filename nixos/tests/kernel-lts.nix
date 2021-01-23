import ./make-test-python.nix ({ pkgs, ...} : {
  name = "kernel-lts";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages;
    };

  testScript =
    ''
      assert "Linux" in machine.succeed("uname -s")
      assert "${pkgs.linuxPackages.kernel.version}" in machine.succeed("uname -a")
    '';
})
