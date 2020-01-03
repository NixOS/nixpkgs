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
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = version;
    sha256 = "1bdmxxkcqpjvkckizmrz2839b4yspw4xv69bqkrrgkcyvxsr804w";
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
