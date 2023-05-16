{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit hash;
  };

  major = "7";
  minor = "4";
<<<<<<< HEAD
  patch = "7";
=======
  patch = "6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
<<<<<<< HEAD
    hash = "sha256-dD2R8qE4png4D6eo7LWyQB2ZSwZ7MwdQ8DrY9SOi+yA=";
=======
    hash = "sha256-GHOuiYbww/DSK/DpSqAaB/jgppKacjGSYIOPqGnmIJM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
<<<<<<< HEAD
    hash = "sha256-7wea0EClmvwcPvgQDGagkOF7eBVvYTZScCEEpirdXnE=";
=======
    hash = "sha256-ES4r9Pk7DYeFTPg8iPXQP84SpGn6x8G10Pfs1WQVixM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
<<<<<<< HEAD
    hash = "sha256-vcQWE3mBZx2sBQ9KzTh6zM7277mK9twfvyESTzTiII8=";
=======
    hash = "sha256-o0JnybhmMFZhcbTrWRllJ+J9+tcUbFLcbftymgECT9E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
