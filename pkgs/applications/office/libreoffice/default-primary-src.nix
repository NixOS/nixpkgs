{ fetchurl }:

rec {
  major = "6";
  minor = "1";
  patch = "1";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "228166908a3404cbb8e6e662f44b1af8644c0589b2309fadce89dcef112fd09d";
  };
}
