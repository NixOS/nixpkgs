{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "2";
  patch = "3";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "sha256-VslzdJVtmMjvzW1YdxwJUMimQe2E/WTbZjgohMTDtFE=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "sha256-B/UVlPyzL7M3PpQwS63huRtti1VR+OaI2nd+T1IESOw=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "sha256-CH4URClK/lq0nqN6LHjAVcKjkADol5AX3WuyAl0srnk=";
  };
}
