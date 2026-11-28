{
  stdenv,
  lib,
  fetchFromGitHub,
  replaceVars,
  cairo,
  cinnamon-desktop,
  desktop-file-utils,
  egl-wayland,
  glib,
  gobject-introspection,
  graphene,
  gtk3,
  json-glib,
  libcanberra,
  libdrm,
  libgbm,
  libgudev,
  libinput,
  libstartup_notification,
  libwacom,
  libxcvt,
  libxdamage,
  libxkbcommon,
  libxkbfile,
  libxtst,
  mesa-gl-headers,
  meson,
  ninja,
  pipewire,
  pkg-config,
  python3,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsHook3,
  xenity,
  xkeyboard-config,
  xorg-server,
  xwayland,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.pygobject3 ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "muffin";
  version = "6.8.6";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "muffin";
    rev = finalAttrs.version;
    hash = "sha256-QgLBqb+VuYOxsAkiFw/leL8vQK6nlmIiYgTs2uHiIv8=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit xenity;
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
    xorg-server # for cvt command
    gobject-introspection
    wayland-scanner
  ];

  buildInputs = [
    cairo
    cinnamon-desktop
    egl-wayland
    glib
    gtk3
    libcanberra
    libdrm
    libgbm
    libgudev
    libinput
    libstartup_notification
    libwacom
    libxcvt
    libxdamage
    libxkbcommon
    libxkbfile
    pipewire
    pythonEnv
    udev
    wayland
    wayland-protocols
    xkeyboard-config
    xwayland
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect muffin-clutter
    json-glib
    libxtst
    graphene
    mesa-gl-headers
  ];

  mesonFlags = [
    # Based on Mint's debian/rules.
    "-Dwayland_eglstream=true"
    "-Dxwayland_path=${lib.getExe xwayland}"
    "-Dudev_dir=${placeholder "out"}/lib/udev"
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  meta = {
    homepage = "https://github.com/linuxmint/muffin";
    description = "Window management library for the Cinnamon desktop (libmuffin) and its sample WM binary (muffin)";
    mainProgram = "muffin";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
