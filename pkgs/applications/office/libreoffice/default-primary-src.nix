{ fetchurl }:

rec {
  major = "5";
  minor = "2";
  patch = "1";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "14g2xwpid4vsgmc69rs7hz1wx96dfkq0cbm32vjgljsm7a19qfc1";
  };
}
