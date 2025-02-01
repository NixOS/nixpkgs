{ lib, stdenv
, fetchFromGitHub

, cmake
, gettext
, wrapGAppsHook3
, pkg-config

, alsa-lib
, binutils
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
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = "xournalpp";
    rev = "v${version}";
    sha256 = "sha256-8UAAX/kixqiY9zEYs5eva0G2K2vlfnYd1yyVHMSfSeY=";
  };

  postPatch = ''
    substituteInPlace src/util/Stacktrace.cpp \
      --replace-fail "addr2line" "${binutils}/bin/addr2line"
  '';

  nativeBuildInputs = [ cmake gettext pkg-config wrapGAppsHook3 ];

  buildInputs =
    lib.optionals stdenv.isLinux [
      alsa-lib
    ] ++ [
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

  meta = with lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage    = "https://xournalpp.github.io/";
    changelog   = "https://github.com/xournalpp/xournalpp/blob/v${version}/CHANGELOG.md";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms   = platforms.unix;
    mainProgram = "xournalpp";
  };
}
