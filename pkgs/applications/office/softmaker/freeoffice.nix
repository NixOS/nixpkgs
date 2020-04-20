{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "freeoffice";
  version = "976";
  edition = "2018";
  suiteName = "FreeOffice";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    sha256 = "13yh4lyqakbdqf4r8vw8imy5gwpfva697iqfd85qmp3wimqvzskl";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
