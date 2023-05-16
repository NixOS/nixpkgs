{ lib, stdenv
, fetchFromGitHub

, cmake
, gettext
, wrapGAppsHook
, pkg-config

<<<<<<< HEAD
, alsa-lib
, glib
, gsettings-desktop-schemas
, gtk3
, gtksourceview4
=======
, glib
, gsettings-desktop-schemas
, gtk3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, librsvg
, libsndfile
, libxml2
, libzip
, pcre
, poppler
, portaudio
, zlib
# plugins
, withLua ? true, lua
}:

stdenv.mkDerivation rec {
  pname = "xournalpp";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dnFNGWPpK/eoW4Ib1E5w/kPy5okPxAja1v4rf0KpVKM=";
=======
    sha256 = "sha256-Hn7IDnbrmK3V+iz8UqdmHRV2TS4MwYSgYtnH6igbGJ8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake gettext pkg-config wrapGAppsHook ];
  buildInputs =
<<<<<<< HEAD
    [
      alsa-lib
      glib
      gsettings-desktop-schemas
      gtk3
      gtksourceview4
=======
    [ glib
      gsettings-desktop-schemas
      gtk3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      librsvg
      libsndfile
      libxml2
      libzip
      pcre
      poppler
      portaudio
      zlib
    ]
    ++ lib.optional withLua lua;

  buildFlags = [ "translations" ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage    = "https://xournalpp.github.io/";
    changelog   = "https://github.com/xournalpp/xournalpp/blob/v${version}/CHANGELOG.md";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ andrew-d sikmir ];
    platforms   = platforms.linux;
  };
}
