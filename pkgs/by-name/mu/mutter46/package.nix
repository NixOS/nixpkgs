{
  fetchurl,
  runCommand,
  lib,
  stdenv,
  pkg-config,
  gettext,
  gobject-introspection,
  cairo,
  colord,
  lcms2,
  pango,
  libstartup_notification,
  libcanberra,
  ninja,
  xvfb-run,
  libxcvt,
  libICE,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXtst,
  libxkbfile,
  xkeyboard_config,
  libxkbcommon,
  libXrender,
  libxcb,
  libXrandr,
  libXinerama,
  libXau,
  libinput,
  libdrm,
  libgbm,
  libei,
  libdisplay-info,
  gsettings-desktop-schemas,
  glib,
  atk,
  gtk4,
  fribidi,
  harfbuzz,
  gnome-desktop,
  pipewire,
  libgudev,
  libwacom,
  libSM,
  xwayland,
  mesa-gl-headers,
  meson,
  gnome-settings-daemon,
  xorgserver,
  python3,
  wayland-scanner,
  wrapGAppsHook4,
  gi-docgen,
  sysprof,
  libsysprof-capture,
  desktop-file-utils,
  egl-wayland,
  graphene,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mutter";
  version = "46.8";

  outputs = [
    "out"
    "dev"
    "man"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${lib.versions.major finalAttrs.version}/mutter-${finalAttrs.version}.tar.xz";
    hash = "sha256-+8CDVEr7O4Vn18pobCF/g3sG+UeNbiV0FZ/5ocjhyWI=";
  };

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dtests=false"
    "-Dwayland_eglstream=true"
    "-Dprofiler=true"
    "-Dxwayland_path=${lib.getExe xwayland}"
    # This should be auto detected, but it looks like it manages a false
    # positive.
    "-Dxwayland_initfd=disabled"
    "-Ddocs=true"
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect mutter-mtk
    graphene
    mesa-gl-headers
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxcvt
    meson
    ninja
    xvfb-run
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook4
    gi-docgen
    xorgserver
    gobject-introspection
  ];

  buildInputs = [
    cairo
    egl-wayland
    glib
    gnome-desktop
    gnome-settings-daemon
    gsettings-desktop-schemas
    atk
    fribidi
    harfbuzz
    libcanberra
    libdrm
    libgbm
    libei
    libdisplay-info
    libgudev
    libinput
    libstartup_notification
    libwacom
    libSM
    colord
    lcms2
    pango
    pipewire
    sysprof # for D-Bus interfaces
    libsysprof-capture
    xwayland
    wayland
    wayland-protocols
    # X11 client
    gtk4
    libICE
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXtst
    libxkbfile
    xkeyboard_config
    libxkbcommon
    libXrender
    libxcb
    libXrandr
    libXinerama
    libXau
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    # TODO: Move this into a directory devhelp can find.
    moveToOutput "share/mutter-14/doc" "$devdoc"
  '';

  # Install udev files into our own tree.
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  separateDebugInfo = true;

  passthru = {
    libdir = "${finalAttrs.finalPackage}/lib/mutter-14";

    tests = {
      libdirExists = runCommand "mutter-libdir-exists" { } ''
        if [[ ! -d ${finalAttrs.finalPackage.libdir} ]]; then
          echo "passthru.libdir should contain a directory, “${finalAttrs.finalPackage.libdir}” is not one."
          exit 1
        fi
        touch $out
      '';
    };
  };

  meta = with lib; {
    description = "Window manager for GNOME";
    mainProgram = "mutter";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    license = licenses.gpl2Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
  };
})
