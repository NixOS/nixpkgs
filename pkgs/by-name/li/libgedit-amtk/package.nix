{
  stdenv,
  lib,
  fetchFromGitHub,
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
  version = "5.8.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "gedit-technology";
    repo = "libgedit-amtk";
    rev = version;
    hash = "sha256-U77/KMZw9k9ukebCXVXAsCa4uJaTgw9irfZ/l0303kk=";
  };

  strictDeps = true;
  nativeBuildInputs =
    [
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

  doCheck = stdenv.isLinux;
  checkPhase = ''
    runHook preCheck

    export NO_AT_BRIDGE=1
    ${xvfb-run}/bin/xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
  };

  meta = with lib; {
    homepage = "https://github.com/gedit-technology/libgedit-amtk";
    description = "Actions, Menus and Toolbars Kit for GTK applications";
    maintainers = with maintainers; [
      manveru
      bobby285271
    ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
