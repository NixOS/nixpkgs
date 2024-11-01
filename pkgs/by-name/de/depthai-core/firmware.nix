{ fetchurl }:

let
  device_side_commit = "8c3d6ac1c77b0bf7f9ea6fd4d962af37663d2fbd";
  device_side_filename = "depthai-device-fwp-${device_side_commit}.tar.xz";
in

fetchurl {
  name = device_side_filename;
  version = "0-commit-${device_side_commit}";
  url = "https://artifacts.luxonis.com/artifactory/luxonis-myriad-snapshot-local/depthai-device-side/${device_side_commit}/${device_side_filename};unpack=0;name=device-fwp";
  hash = "sha256-ewNrmrG1wg033/1Jd8y+HEO1Tb93Ciq7zc/T1P/fBLE=";
}
