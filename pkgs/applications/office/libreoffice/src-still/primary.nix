{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "7";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "T98ICdiAM4i9E6zis0V/Cmq5+e98mNb0bMZA//xelLo=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "g8skm02R5nRyF09ZbL9kJqMxRqaQ0AfpletDK3AAggk=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "jAFrO4RyONhPH3H5QW0SL8Id53bBvJ7AYxSNtLhG4rQ=";
  };
}
