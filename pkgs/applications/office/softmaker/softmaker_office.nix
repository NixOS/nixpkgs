{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "softmaker-office";
  version = "970";
  edition = "2018";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
    sha256 = "14f94p1jms41s2iz5sa770rcyfp4mv01r6jjjis9amx37zrc8yid";
  };

  archive = "office${edition}.tar.lzma";
})
