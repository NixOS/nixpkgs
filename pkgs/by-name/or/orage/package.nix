{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  glib,
  gtk3,
  libical,
  libnotify,
  libxfce4ui,
  libxfce4util,
  tzdata,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orage";
  version = "4.20.2";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "orage";
    tag = "orage-${finalAttrs.version}";
    hash = "sha256-iV4eVYmOXfEpq5cnHeCXRvx0Ms0Dis3EIwbcSakGLXs=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libical
    libnotify
    libxfce4ui
    libxfce4util
  ];

  postPatch = ''
    substituteInPlace src/parameters.c        --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace src/tz_zoneinfo_read.c  --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "orage-";
    odd-unstable = true;
  };

  meta = {
    description = "Simple calendar application for Xfce";
    homepage = "https://gitlab.xfce.org/apps/orage";
    license = lib.licenses.gpl2Plus;
    mainProgram = "orage";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
