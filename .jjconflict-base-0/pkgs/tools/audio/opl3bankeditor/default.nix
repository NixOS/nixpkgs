import ./common.nix rec {
  pname = "opl3bankeditor";
  chip = "OPL3";
  version = "1.5.1";
  sha256 = "08krbxlxgmc7i2r2k6d6wgi0m6k8hh3j60xf21kz4kp023w613sa";
  extraPatches = [
    ./0001-opl3bankeditor-Look-for-system-installed-Rt-libs.patch
  ];
}
