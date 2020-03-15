{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "974";
  edition = "2018";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "0z1g76lhja92s25x6y0h55wmqza2d3pjbshn5b9rn2784gjgj7hn";
  };

  archive = "office${edition}.tar.lzma";
})
