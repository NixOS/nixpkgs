{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  appstream-glib,
  desktop-file-utils,
  gettext,
  glib,
  gobject-introspection,
  gtk3,
  hicolor-icon-theme,
  libappindicator,
  libhandy,
  meson,
  pkg-config,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "cpupower-gui";
  version = "1.0.0";

  # This packages doesn't have a setup.py
  pyproject = false;

  src = fetchFromGitHub {
    owner = "vagnum08";
    repo = "cpupower-gui";
    tag = "v${version}";
    sha256 = "05lvpi3wgyi741sd8lgcslj8i7yi3wz7jwl7ca3y539y50hwrdas";
  };

  patches = [
    # Fix build with 0.61, can be removed on next update
    # https://hydra.nixos.org/build/171052557/nixlog/1
    (fetchpatch {
      url = "https://github.com/vagnum08/cpupower-gui/commit/97f8ac02fe33e412b59d3f3968c16a217753e74b.patch";
      sha256 = "XYnpm03kq8JLMjAT73BMCJWlzz40IAuHESm715VV6G0=";
    })
    # Fixes https://github.com/vagnum08/cpupower-gui/issues/86
    (fetchpatch {
      url = "https://github.com/vagnum08/cpupower-gui/commit/22ea668aa4ecf848149ea4c150aa840a25dc6ff8.patch";
      sha256 = "sha256-Mri7Af1Y79lt2pvZl4DQSvrqSLIJLIjzyXwMPFEbGVI=";
    })
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils # needed for update-desktop-database
    gettext
    glib # needed for glib-compile-schemas
    gobject-introspection # need for gtk namespace to be available
    hicolor-icon-theme # needed for postinstall script
    meson
    python3Packages.ninja
    pkg-config
    wrapGAppsHook3

    # Python packages
    python3Packages.dbus-python
    libappindicator
    python3Packages.pygobject3
    python3Packages.pyxdg
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
  ];

  propagatedBuildInputs = [
    python3Packages.dbus-python
    libappindicator
    python3Packages.pygobject3
    python3Packages.pyxdg
  ];

  mesonFlags = [
    "-Dsystemddir=${placeholder "out"}/lib/systemd"
  ];

  preConfigure = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  strictDeps = false;
  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postFixup = ''
    wrapPythonProgramsIn $out/lib "$out $propagatedBuildInputs"
  '';

  meta = {
    description = "Change the frequency limits of your cpu and its governor";
    mainProgram = "cpupower-gui";
    homepage = "https://github.com/vagnum08/cpupower-gui/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ unode ];
  };
}
