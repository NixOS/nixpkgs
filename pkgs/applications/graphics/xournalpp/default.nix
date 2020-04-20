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
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = version;
    sha256 = "0xw2mcgnm4sa9hrhfgp669lfypw97drxjmz5w8i5whaprpvmkxzw";
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
