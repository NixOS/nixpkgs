{ stdenv
, fetchFromGitHub

, cmake
, gettext
, wrapGAppsHook
, pkg-config

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
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = version;
    sha256 = "1c7n03xm3m4lwcwxgplkn25i8c6s3i7rijbkcx86br1j4jadcs3k";
  };

  nativeBuildInputs = [ cmake gettext pkg-config wrapGAppsHook ];
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

  meta = with stdenv.lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage    = "https://xournalpp.github.io/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ andrew-d sikmir ];
    platforms   = platforms.linux;
  };
}
