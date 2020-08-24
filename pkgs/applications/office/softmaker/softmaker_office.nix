{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "1018";
  edition = "2021";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "1g9mcn0z7s3xw7d5bcjxbnamh6knzndcysahydskfcds6czdxg0c";
  };

  archive = "office${edition}.tar.lzma";
})
