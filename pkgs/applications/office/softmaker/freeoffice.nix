{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "freeoffice";
  version = "978";
  edition = "2018";
  suiteName = "FreeOffice";

  src = fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
    sha256 = "1c5div1kbyyj48f89wkhc1i1759n70bsbp3w4a42cr0jmllyl60v";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
