{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  mate-common,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  mate-desktop,
  dconf,
  vte,
  pcre2,
  wrapGAppsHook3,
  yelp-tools,
  gitUpdater,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-terminal";
  version = "1.28.3";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-terminal";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-fgmYqcv+36QjOFVB7gdBrUi6eZhWFLsJa3Pm27Idx8E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    gettext
    itstool
    mate-common # mate-common.m4 macros
    pkg-config
    libxml2 # xmllint
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    dconf
    mate-desktop
    pcre2
    vte
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  passthru.tests.test = nixosTests.terminal-emulators.mate-terminal;

  meta = {
    description = "MATE desktop terminal emulator";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
