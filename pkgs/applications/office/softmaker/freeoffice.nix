{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "freeoffice";
  version = "974";
  edition = "2018";
  suiteName = "FreeOffice";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    sha256 = "0z7131qmqyv1m9phm7wzvb5z7wkh27h59lsa3zc0zjkykikmjrp2";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
