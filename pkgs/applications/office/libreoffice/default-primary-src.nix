{ fetchurl }:

rec {
  major = "5";
  minor = "2";
  patch = "4";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "047byvyg13baws1bycaq1s6wqhkcr2pk27xbag0npzx1lspx2wwb";
  };
}
