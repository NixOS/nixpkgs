{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit hash;
  };

  major = "7";
  minor = "4";
  patch = "7";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    hash = "sha256-dD2R8qE4png4D6eo7LWyQB2ZSwZ7MwdQ8DrY9SOi+yA=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    hash = "sha256-7wea0EClmvwcPvgQDGagkOF7eBVvYTZScCEEpirdXnE=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    hash = "sha256-vcQWE3mBZx2sBQ9KzTh6zM7277mK9twfvyESTzTiII8=";
  };
}
