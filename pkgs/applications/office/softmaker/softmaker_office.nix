{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "978";
  edition = "2018";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "14qnlbczq1zcz24vwy2yprdvhyn6bxv1nc1w6vjyq8w5jlwqsgbr";
  };

  archive = "office${edition}.tar.lzma";
})
