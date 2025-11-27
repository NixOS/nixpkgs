{
  fetchurl,
  runCommand,
  lib,
  stdenv,
  pkg-config,
  gnome,
  gettext,
  gobject-introspection,
  cairo,
  colord,
  docutils,
  lcms2,
  pango,
  libstartup_notification,
  libcanberra,
  ninja,
  xvfb-run,
  libadwaita,
  libxcvt,
  libGL,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  xkeyboard_config,
  libxkbcommon,
  libxcb,
  libXrandr,
  libXinerama,
  libXau,
  libinput,
  libdrm,
  libgbm,
  libei,
  libepoxy,
  libdisplay-info,
  gsettings-desktop-schemas,
  glib,
  libglycin,
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
  udevCheckHook,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mutter";
  version = "49.2";

  outputs = [
    "out"
    "dev"
    "man"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${lib.versions.major finalAttrs.version}/mutter-${finalAttrs.version}.tar.xz";
    hash = "sha256-J2ORoIDlCVaSQKyGECVdd4q2qIoyUPmxd0AlXxNOPAo=";
  };

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dtests=disabled"
    # For NVIDIA proprietary driver up to 470.
    # https://src.fedoraproject.org/rpms/mutter/pull-request/49
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
    docutils # for rst2man
    gettext
    glib
    libxcvt
    meson
    ninja
    xvfb-run
    pkg-config
    python3
    python3.pkgs.argcomplete # for register-python-argcomplete
    wayland-scanner
    wrapGAppsHook4
    gi-docgen
    xorgserver
    gobject-introspection
    udevCheckHook
  ];

  buildInputs = [
    cairo
    egl-wayland
    glib
    libglycin
    gnome-desktop
    gnome-settings-daemon
    gsettings-desktop-schemas
    atk
    fribidi
    harfbuzz
    libcanberra
    libdrm
    libadwaita
    libgbm
    libei
    libepoxy
    libdisplay-info
    libGL
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
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    xkeyboard_config
    libxkbcommon
    libxcb
    libXrandr
    libXinerama
    libXau

    # for gdctl and gnome-service-client shebangs
    (python3.withPackages (pp: [
      pp.dbus-python
      pp.pygobject3
      pp.argcomplete
    ]))
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py

    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3981
    substituteInPlace src/frames/main.c \
      --replace-fail "libadwaita-1.so.0" "${libadwaita}/lib/libadwaita-1.so.0"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    # TODO: Move this into a directory devhelp can find.
    moveToOutput "share/mutter-${finalAttrs.passthru.libmutter_api_version}/doc" "$devdoc"
  '';

  # Install udev files into our own tree.
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  separateDebugInfo = true;
  strictDeps = true;

  doInstallCheck = true;

  passthru = {
    libmutter_api_version = "17"; # bumped each dev cycle
    libdir = "${finalAttrs.finalPackage}/lib/mutter-${finalAttrs.passthru.libmutter_api_version}";

    tests = {
      libdirExists = runCommand "mutter-libdir-exists" { } ''
        if [[ ! -d ${finalAttrs.finalPackage.libdir} ]]; then
          echo "passthru.libdir should contain a directory, “${finalAttrs.finalPackage.libdir}” is not one."
          exit 1
        fi
        touch $out
      '';
    };

    updateScript = gnome.updateScript {
      packageName = "mutter";
    };
  };

  meta = with lib; {
    description = "Window manager for GNOME";
    mainProgram = "mutter";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    changelog = "https://gitlab.gnome.org/GNOME/mutter/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})
