{ fetchurl }:

rec {
  major = "5";
  minor = "2";
  patch = "5";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "006kn1m5d6c1skgc1scc0gssin922raca2psjv887alplhia6mlp";
  };
}
