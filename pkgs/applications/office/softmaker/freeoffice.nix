{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "freeoffice";
  version = "970";
  edition = "2018";
  suiteName = "FreeOffice";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    sha256 = "1maibr4x8mksb32ixvyy2rjn4x9f51191p5fcdj5qwz32pf8h2dr";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
