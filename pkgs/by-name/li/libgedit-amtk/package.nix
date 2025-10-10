{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
  gtk3,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gobject-introspection,
  gtk-doc,
  docbook-xsl-nons,
  gitUpdater,
  dbus,
  xvfb-run,
}:

stdenv.mkDerivation rec {
  pname = "libgedit-amtk";
  version = "5.9.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-amtk";
    rev = version;
    hash = "sha256-myKpZtqtf40UByBUKVF0jv521kGAUA6KDmbDJy/Q1q8=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  propagatedBuildInputs = [
    # Required by libgedit-amtk-5.pc
    glib
    gtk3
  ];

  nativeCheckInputs = [
    dbus # For dbus-run-session
  ];

  doCheck = stdenv.hostPlatform.isLinux;
  checkPhase = ''
    runHook preCheck

    export NO_AT_BRIDGE=1
    ${xvfb-run}/bin/xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater { ignoredVersions = "(alpha|beta|rc).*"; };

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-amtk";
    changelog = "https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/blob/${version}/NEWS?ref_type=tags";
    description = "Actions, Menus and Toolbars Kit for GTK applications";
    maintainers = with lib.maintainers; [
      manveru
      bobby285271
    ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
