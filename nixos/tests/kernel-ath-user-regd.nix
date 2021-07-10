import ./make-test-python.nix ({ pkgs, ...} : {
  name = "kernel-ath-user-regd";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ veehaitch ];
  };

  default = { pkgs, ... }:
    {
      networking.wireless.athUserRegulatoryDomain = true;
    };

  latest = { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
      networking.wireless.athUserRegulatoryDomain = true;
    };

  testScript =
    ''
      assert "CONFIG_ATH_USER_REGD=y" in default.succeed("zcat /proc/config.gz")
      assert "CONFIG_ATH_USER_REGD=y" in latest.succeed("zcat /proc/config.gz")
    '';
})
