{ lib, stdenv
, fetchFromGitHub

, cmake
, gettext
, wrapGAppsHook
, pkg-config

, alsa-lib
, glib
, gsettings-desktop-schemas
, gtk3
, gtksourceview4
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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dnFNGWPpK/eoW4Ib1E5w/kPy5okPxAja1v4rf0KpVKM=";
  };

  nativeBuildInputs = [ cmake gettext pkg-config wrapGAppsHook ];
  buildInputs =
    [
      alsa-lib
      glib
      gsettings-desktop-schemas
      gtk3
      gtksourceview4
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
