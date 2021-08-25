{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "5";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1kl54ddpvmrcs4r1vd4dfzg5a8im0kijhaqdg37zvgb5fqv31bxf";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "0nf5s012l7mkpd1srvijl9q6x8f7svm6i84bj75dwyvipkg40rxq";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1m1hxbhrkaynpcps77rym1d0kwl380jv1p7b6ibfl4by0ii2j16a";
  };
}
