{ fetchurl }:

rec {
  major = "6";
  minor = "1";
  patch = "0";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "54eccd268f75d62fa6ab78d25685719c109257e1c0f4d628eae92ec09632ebd8";
  };
}
