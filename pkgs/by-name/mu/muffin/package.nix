{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  replaceVars,
  cairo,
  cinnamon-desktop,
  dbus,
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
  libgnomekbd,
  libgudev,
  libinput,
  libstartup_notification,
  libwacom,
  libxcvt,
  libXdamage,
  libxkbcommon,
  libXtst,
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
  xorgserver,
  xwayland,
  zenity,
}:

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "6.4.1";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "muffin";
    rev = version;
    hash = "sha256-cGC1yGft3uEqefm2DvZrMaROoZKYd6LNY0IJ+58f6vs=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit zenity;
    })

    # Fix Qt apps crashing on wayland
    # https://github.com/linuxmint/muffin/pull/739
    (fetchpatch {
      url = "https://github.com/linuxmint/muffin/commit/760e2a3046e13610c4fda1291a9a28e589d2bd93.patch";
      hash = "sha256-D0u8UxW5USzMW9KlP3Y4XCWxrQ1ySufDv+eCbrAP71c=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
    xorgserver # for cvt command
    gobject-introspection
    wayland-scanner
  ];

  buildInputs = [
    cairo
    cinnamon-desktop
    dbus
    egl-wayland
    glib
    gtk3
    libcanberra
    libdrm
    libgbm
    libgnomekbd
    libgudev
    libinput
    libstartup_notification
    libwacom
    libxcvt
    libXdamage
    libxkbcommon
    pipewire
    udev
    wayland
    wayland-protocols
    xwayland
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect muffin-clutter
    json-glib
    libXtst
    graphene
    mesa-gl-headers
  ];

  mesonFlags = [
    # Based on Mint's debian/rules.
    "-Degl_device=true"
    "-Dwayland_eglstream=true"
    "-Dxwayland_path=${lib.getExe xwayland}"
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/muffin";
    description = "Window management library for the Cinnamon desktop (libmuffin) and its sample WM binary (muffin)";
    mainProgram = "muffin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
