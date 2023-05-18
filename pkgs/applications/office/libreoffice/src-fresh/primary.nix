{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    sha256 = hash;
  };

  major = "7";
  minor = "5";
  patch = "2";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    hash = "sha256-YYuQfdNrj4DgfdwTpgXo58EhJh323cmmQ24FQUMkLdM=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    hash = "sha256-IPdXQibM+xz1Wok/XnRxyNVqvwh4BarWCH9FceylN/0=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    hash = "sha256-h1uQ3EaroSyz6uCU7SFC06TuGMvaXm97/v9zCKvNxDY=";
  };
}
