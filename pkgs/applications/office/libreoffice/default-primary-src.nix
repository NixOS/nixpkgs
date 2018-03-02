{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "2";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0qga01lhh09jf2gx3czk66i5c854gzzjxgkrmj5d7m4ci2zaxfsd";
  };
}
