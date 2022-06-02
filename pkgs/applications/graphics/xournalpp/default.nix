{ lib, stdenv
, fetchFromGitHub

, cmake
, gettext
, wrapGAppsHook
, pkg-config

, glib
, gsettings-desktop-schemas
, gtk3
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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AzLkXGcTjtfBaPOZ/Tc+TwL63vm08G2tZw3pGzoo7po=";
  };

  nativeBuildInputs = [ cmake gettext pkg-config wrapGAppsHook ];
  buildInputs =
    [ glib
      gsettings-desktop-schemas
      gtk3
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

  buildFlags = "translations";

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
