{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "2";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "sha256-SDdlqYuS2Q6MjHNeCNM8KjS1/h+8jn9rH5x0rRoUHjE=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "sha256-fUZflmrCi4mOa6iZTm+K9IvRTlSjcI4UJ4EoyK/HHck=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "sha256-TjAgz7yV7y5VNrEuT2eElkNGZzh6J58T1TC3u2Ap2o4=";
  };
}
