{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "freeoffice";
  version = "966";
  edition = "2018";
  suiteName = "FreeOffice";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    sha256 = "18s92d2pmhmd56sb9c1zirwxzfgpqd8wh11bl0zi6g6skn68zhx4";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
