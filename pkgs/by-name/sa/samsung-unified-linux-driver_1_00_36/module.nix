# the original samsung-unified-linux-driver_1_00_36 has some paths
# hardcoded in binary files
#
# nixos samsung-unified-linux-driver_1_00_36 tries to fix those paths
# by patching the binaries
#
# this module is needed to put the expected files in the new paths
#
# printing works without problems
#
# scanning works, except one detail: sometimes it is possible to scan
# more pages in sequence.  most of the time though, scanning stops
# working after one page.  this problem happens both with scanimage
# and simple-scan.  errors indicate an I/O error.  scanning works
# again after turning the device off and on.  atm i have no idea how
# to fix this and no time to do more about it.
{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  cfg = config.services.samsung-unified-linux-driver_1_00_36;
  pkg = pkgs.samsung-unified-linux-driver_1_00_36;
in
{
  options = {
    services.samsung-unified-linux-driver_1_00_36 = {
      enable = lib.mkEnableOption "samsung-unified-linux-driver_1_00_36";
    };
  };
  config = lib.mkIf cfg.enable {
    services.printing.drivers = [ pkg ];
    hardware.sane.extraBackends = [ pkg ];
    environment.etc = {
      "samsung/scanner/share/oem.conf".source = "${pkg}/etc/samsung/scanner/share/oem.conf";
      "smfp-common/scanner/share/libsane-smfp.cfg".source =
        "${pkg}/etc/smfp-common/scanner/share/libsane-smfp.cfg";
      "smfp-common/scanner/share/pagesize.xml".source =
        "${pkg}/etc/smfp-common/scanner/share/pagesize.xml";
      "sane.d/smfp.conf".source = "${pkg}/etc/sane.d/smfp.conf";
      "sane.d/dll.d/smfp-scanner.conf".source = "${pkg}/etc/sane.d/dll.d/smfp-scanner.conf";
    };
  };
}
