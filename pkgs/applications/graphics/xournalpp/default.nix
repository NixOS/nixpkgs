{ stdenv
, lib
, fetchFromGitHub

, cmake
, gettext
, wrapGAppsHook
, pkgconfig

, glib
, gsettings-desktop-schemas
, gtk3
, hicolor-icon-theme
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
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = "xournalpp";
    rev = version;
    sha256 = "0yg70hsx58s3wb5kzccivrqa7kvmdapygxmif1j64hddah2rqcn9";
  };

  nativeBuildInputs = [ cmake gettext pkgconfig wrapGAppsHook ];
  buildInputs =
    [ glib
      gsettings-desktop-schemas
      gtk3
      hicolor-icon-theme
      libsndfile
      libxml2
      libzip
      pcre
      poppler
      portaudio
      zlib
    ]
    ++ lib.optional withLua lua;

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage    = https://github.com/xournalpp/xournalpp;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ andrew-d ];
    platforms   = platforms.linux;
  };
}
