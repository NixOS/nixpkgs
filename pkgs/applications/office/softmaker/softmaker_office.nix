{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "972";
  edition = "2018";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "06kgkmqg5269a4vm14i89mw8m1x9yy9ajw0dhfcvjizadyzmlqn1";
  };

  archive = "office${edition}.tar.lzma";
})
