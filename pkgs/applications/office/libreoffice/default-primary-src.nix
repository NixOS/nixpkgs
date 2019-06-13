{ fetchurl }:

rec {
  major = "6";
  minor = "2";
  patch = "3";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1bvdvhk1jw16wc0fd7vvvjyn7ydwy9i3xa3d8kn1bdmsn97vkpgi";
  };
}
