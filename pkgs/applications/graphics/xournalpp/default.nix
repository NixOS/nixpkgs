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
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = version;
    sha256 = "0a9ygbmd4dwgck3k8wsrm2grynqa0adb12wwspzmzvpisbadffjy";
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
    homepage    = "https://github.com/xournalpp/xournalpp";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ andrew-d sikmir ];
    platforms   = platforms.linux;
  };
}
