{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    sha256 = hash;
  };

  major = "7";
  minor = "5";
  patch = "4";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    hash = "sha256-dWE7yXldkiEnsJOxfxyZ9p05eARqexgRRgNV158VVF4=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    hash = "sha256-dv3L8DtdxZcwmeXnqtTtwIpOvwZg3aH3VvJBiiZzbh0=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    hash = "sha256-2CrGEyK5AQEAo1Qz1ACmvMH7BaOubW5BNLWv3fDEdOY=";
  };
}
