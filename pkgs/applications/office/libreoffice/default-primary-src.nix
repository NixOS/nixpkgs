{ fetchurl }:

rec {
  major = "6";
  minor = "1";
  patch = "2";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "650c57b60f880db28e49e584f42018da9e714865dfa94fbb8391de15b58a3f91";
  };
}
