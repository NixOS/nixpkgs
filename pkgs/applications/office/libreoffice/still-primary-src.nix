{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "f1666430abf616a3813e4c886b51f157366f592102ae0e874abc17f3d58c6a8e";
  };
}
