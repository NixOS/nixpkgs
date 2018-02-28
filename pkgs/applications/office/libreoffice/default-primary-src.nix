{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "1";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1abhas5hc0whibz39msk4r7njyrm7w8k0idk0y522ifndsf2m04g";
  };
}
