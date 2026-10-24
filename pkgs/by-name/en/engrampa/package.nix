{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  caja,
  gtk3,
  hicolor-icon-theme,
  json-glib,
  mate-common,
  mate-desktop,
  wrapGAppsHook3,
  yelp-tools,
  gitUpdater,
  # can be defaulted to true once switch to meson
  withMagic ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "engrampa";
  version = "1.28.5";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "engrampa";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-v23uDb9WC7t0fIAGK20z+7I3NzbgWPH+POuE28jBfSk=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    itstool
    libxml2 # for xmllint
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    caja
    gtk3
    hicolor-icon-theme
    json-glib
    mate-desktop
  ]
  ++ lib.optionals withMagic [
    file
  ];

  configureFlags = [
    "--with-cajadir=$$out/lib/caja/extensions-2.0"
  ]
  ++ lib.optionals withMagic [
    "--enable-magic"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Archive Manager for MATE";
    mainProgram = "engrampa";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
