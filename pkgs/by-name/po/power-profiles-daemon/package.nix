{
  stdenv,
  lib,
  bash-completion,
  pkg-config,
  meson,
  mesonEmulatorHook,
  ninja,
  fetchFromGitLab,
  libgudev,
  glib,
  polkit,
  dbus,
  gobject-introspection,
  wrapGAppsNoGuiHook,
  gettext,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  libxml2,
  libxslt,
  upower,
  umockdev,
  systemd,
  python3,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "power-profiles-daemon";
  version = "0.30";

  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "power-profiles-daemon";
    rev = finalAttrs.version;
    hash = "sha256-iQUhA46BEln8pyIBxM/MY7An8BzfiFjxZdR/tUIj4S4=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
    libxml2 # for xmllint for stripping GResources
    libxslt # for xsltproc for building docs
    gobject-introspection
    wrapGAppsNoGuiHook
    # checkInput but checked for during the configuring
    (python3.pythonOnBuildForHost.withPackages (
      ps: with ps; [
        pygobject3
        dbus-python
        python-dbusmock
        argparse-manpage
        shtab
      ]
    ))
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    bash-completion
    libgudev
    systemd
    upower
    glib
    polkit
    # for cli tool
    (python3.withPackages (ps: [
      ps.pygobject3
    ]))
  ];

  strictDeps = true;

  checkInputs = [
    umockdev
  ];

  nativeCheckInputs = [
    umockdev
    dbus
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=true"
    "-Dpylint=disabled"
    "-Dzshcomp=${placeholder "out"}/share/zsh/site-functions"
    "-Dtests=${lib.boolToString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)}"
  ];

  doCheck = true;

  # Only need to wrap the Python tool (powerprofilectl)
  dontWrapGApps = true;

  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  postPatch = ''
    patchShebangs --build \
      tests/integration-test.py \
      tests/unittest_inspector.py

    patchShebangs --host \
      src/powerprofilesctl
  '';

  postFixup = ''
    wrapGApp "$out/bin/powerprofilesctl"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      nixos = nixosTests.power-profiles-daemon;
    };
  };

  meta = with lib; {
    changelog = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/releases/${finalAttrs.version}";
    homepage = "https://gitlab.freedesktop.org/upower/power-profiles-daemon";
    description = "Makes user-selected power profiles handling available over D-Bus";
    mainProgram = "powerprofilesctl";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      mvnetbiz
      picnoir
      lyndeno
    ];
  };
})
