{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "1";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1vz028hzbc4n8jznigs419ygylz1vp426dprrkm62bzckv2p1rfn";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "1vidv8077f394zn87b2ng1hsld0hgr1zb1p9lmjx0n9k7s7clavh";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "14wn0lvvplsj194jdqqv184xx0adb4mm8bjflddvcqsl7xsfqx27";
  };
}
