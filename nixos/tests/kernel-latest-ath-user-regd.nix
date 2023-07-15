import ./make-test-python.nix ({ pkgs, ...} : {
  name = "kernel-latest-ath-user-regd";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ veehaitch ];
  };

  nodes.machine = { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
      networking.wireless.athUserRegulatoryDomain = true;
    };

  testScript =
    ''
      assert "CONFIG_ATH_USER_REGD=y" in machine.succeed("zcat /proc/config.gz")
    '';
})
