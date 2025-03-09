{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  gettext,
  wrapGAppsHook3,
  pkg-config,

  adwaita-icon-theme,
  alsa-lib,
  binutils,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  gtksourceview4,
  librsvg,
  libsndfile,
  libxml2,
  libzip,
  pcre,
  poppler,
  portaudio,
  zlib,
  # plugins
  withLua ? true,
  lua,
}:

stdenv.mkDerivation rec {
  pname = "xournalpp";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = "xournalpp";
    rev = "v${version}";
    hash = "sha256-Hm3NDVELOnwjg6NiV5VBbt/15slHAgOVZLTV3zBMkLI=";
  };

  postPatch = ''
    substituteInPlace src/util/Stacktrace.cpp \
      --replace-fail "addr2line" "${binutils}/bin/addr2line"
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ [
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

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share"
    )
  '';

  meta = with lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage = "https://xournalpp.github.io/";
    changelog = "https://github.com/xournalpp/xournalpp/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    mainProgram = "xournalpp";
  };
}
