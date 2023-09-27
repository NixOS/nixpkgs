{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit hash;
  };

  major = "7";
  minor = "5";
  patch = "7";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    hash = "sha256-ZZMvlHHYBnu2bE5UQRnRbmPkrsvhJF+xD4anUdLRKxA=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    hash = "sha256-hMG+f57fUat1inRAwlg1dgr1qU5hPM/C8jRTrZG1sP8=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    hash = "sha256-Yz0pCiUY5Tk2NNXlYKM0jWvOwFfNplXogrvjATBn71I=";
  };
}
