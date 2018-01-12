{ fetchurl }:

rec {
  major = "5";
  minor = "3";
  patch = "6";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "023a7hr7v5cf0ipga4ijhyl58ncgbjrp500qq5fwf65j8g2c3apz";
  };
}
