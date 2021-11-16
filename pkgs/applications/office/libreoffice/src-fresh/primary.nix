{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "2";
  patch = "2";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0w9bn3jhrhaj80qbbs8wp3q5yc0rrpwvqj3abgrllg4clk5c6fw1";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "1rhwrax5fxgdvizv74npysam5i67669myysldiplqiah5np672lq";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1hn56irlkk2ng7wzhiv8alpjcnf7xf95n3syzlbnmcj177kpg883";
  };
}
