{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wayland-scanner,
  glib,
  gtk3,
  libdisplay-info,
  libwnck,
  libx11,
  libxrandr,
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

  patches = [
    # Headers depend on gtk3 but it is only listed in Requires.private,
    # which does not influence Cflags on non-static builds in nixpkgs’s
    # pkg-config. Let’s add it to Requires to ensure Cflags are set correctly.
    ./pkg-config-requires.patch
  ];

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [
    glib
    libdisplay-info
    libwnck
    libx11
    libxrandr
    wayland
    wayland-protocols
    wlr-protocols
  ];

  propagatedBuildInputs = [
    gtk3
  ];

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

  mesonFlags = [
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonEnable "vala" withIntrospection)
  ];

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
