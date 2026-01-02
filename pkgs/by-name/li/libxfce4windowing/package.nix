{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  python3,
  wayland-scanner,
  xfce4-dev-tools,
  glib,
  gtk3,
  libdisplay-info,
  libwnck,
  libX11,
  libXrandr,
  wayland,
  wayland-protocols,
  wlr-protocols,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxfce4windowing";
  version = "4.20.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "libxfce4windowing";
    tag = "libxfce4windowing-${finalAttrs.version}";
    hash = "sha256-TVu6S/Cip9IqniAvrTU5uSs7Dgm0WZNxjgB4vjHvBNU=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    python3
    wayland-scanner
    xfce4-dev-tools
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    libdisplay-info
    libwnck
    libX11
    libXrandr
    wayland
    wayland-protocols
    wlr-protocols
  ];

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "libxfce4windowing-";
    odd-unstable = true;
  };

  meta = {
    description = "Windowing concept abstraction library for X11 and Wayland";
    homepage = "https://gitlab.xfce.org/xfce/libxfce4windowing";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
