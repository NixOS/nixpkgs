{ fetchurl }:

rec {
  major = "5";
  minor = "2";
  patch = "3";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1h9j3j7drhr49nw2p6by5vvrr8nc8rpldn3yp724mwkb2rfkdwd8";
  };
}
