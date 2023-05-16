{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    sha256 = hash;
  };

  major = "7";
  minor = "5";
<<<<<<< HEAD
  patch = "4";
  tweak = "1";
=======
  patch = "2";
  tweak = "2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
<<<<<<< HEAD
    hash = "sha256-dWE7yXldkiEnsJOxfxyZ9p05eARqexgRRgNV158VVF4=";
=======
    hash = "sha256-YYuQfdNrj4DgfdwTpgXo58EhJh323cmmQ24FQUMkLdM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
<<<<<<< HEAD
    hash = "sha256-dv3L8DtdxZcwmeXnqtTtwIpOvwZg3aH3VvJBiiZzbh0=";
=======
    hash = "sha256-IPdXQibM+xz1Wok/XnRxyNVqvwh4BarWCH9FceylN/0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
<<<<<<< HEAD
    hash = "sha256-2CrGEyK5AQEAo1Qz1ACmvMH7BaOubW5BNLWv3fDEdOY=";
=======
    hash = "sha256-h1uQ3EaroSyz6uCU7SFC06TuGMvaXm97/v9zCKvNxDY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
