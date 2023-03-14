{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit hash;
  };

  major = "7";
  minor = "4";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    hash = "sha256-GHOuiYbww/DSK/DpSqAaB/jgppKacjGSYIOPqGnmIJM=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    hash = "sha256-ES4r9Pk7DYeFTPg8iPXQP84SpGn6x8G10Pfs1WQVixM=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    hash = "sha256-o0JnybhmMFZhcbTrWRllJ+J9+tcUbFLcbftymgECT9E=";
  };
}
