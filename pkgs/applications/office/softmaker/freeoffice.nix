{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "freeoffice";
  version = "973";
  edition = "2018";
  suiteName = "FreeOffice";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    sha256 = "0xac4ynf1lfh8qmni5bhp4ybaamdfngva4bqaq21n1m4pgrx1ba5";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
