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
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E/7S4JGLXR8u9fE8bTVPFb6XVKOC/BHnQwLhr7N2A48=";
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
