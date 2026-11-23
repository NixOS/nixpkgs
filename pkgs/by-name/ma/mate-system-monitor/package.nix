{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  itstool,
  gtkmm3,
  libxml2,
  libgtop,
  librsvg,
  polkit,
  systemdLibs,
  wrapGAppsHook3,
  mate-common,
  mate-desktop,
  yelp-tools,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-system-monitor";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-system-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aGjqpEIj5J9XQJ/XM33ByAS47ev5EW736JzrLERzNIc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    itstool
    libxml2 # xmllint
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    gtkmm3
    libxml2
    libgtop
    librsvg
    polkit
    systemdLibs
  ];

  postPatch = ''
    # This package does not provide mate-version.xml.
    substituteInPlace src/sysinfo.cpp \
      --replace-fail 'DATADIR "/mate-about/mate-version.xml"' '"${mate-desktop}/share/mate-about/mate-version.xml"'
  '';

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "System monitor for the MATE desktop";
    mainProgram = "mate-system-monitor";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
