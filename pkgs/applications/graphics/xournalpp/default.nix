{ stdenv
, fetchFromGitHub

, cmake
, gettext
, wrapGAppsHook
, pkgconfig

, glib
, gsettings-desktop-schemas
, gtk3
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
  version = "1.0.19";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = version;
    sha256 = "05nx4cmrka6hwdn7r91yy4h46qpa9k7iy9dkgaq3hrkh9z3fxlkq";
  };

  nativeBuildInputs = [ cmake gettext pkgconfig wrapGAppsHook ];
  buildInputs =
    [ glib
      gsettings-desktop-schemas
      gtk3
      libsndfile
      libxml2
      libzip
      pcre
      poppler
      portaudio
      zlib
    ]
    ++ stdenv.lib.optional withLua lua;

  buildFlags = "translations";

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage    = "https://xournalpp.github.io/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ andrew-d sikmir ];
    platforms   = platforms.linux;
  };
}
