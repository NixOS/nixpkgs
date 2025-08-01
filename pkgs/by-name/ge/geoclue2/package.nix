{
  lib,
  stdenv,
  fetchFromGitLab,
  intltool,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  glib,
  json-glib,
  libsoup_3,
  libnotify,
  gdk-pixbuf,
  modemmanager,
  avahi,
  glib-networking,
  python3,
  wrapGAppsHook3,
  gobject-introspection,
  vala,
  withDemoAgent ? false,
  nix-update-script,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geoclue";
  version = "2.7.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "geoclue";
    repo = "geoclue";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-LwL1WtCdHb/NwPr3/OLISwaAwplhJwiZT9vUdX29Bbs=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    meson
    ninja
    wrapGAppsHook3
    python3
    vala
    gobject-introspection
    # devdoc
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    json-glib
    libsoup_3
    avahi
  ]
  ++ lib.optionals withDemoAgent [
    libnotify
    gdk-pixbuf
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    modemmanager
  ];

  propagatedBuildInputs = [
    glib
    glib-networking
  ];

  mesonFlags = [
    "-Dsystemd-system-unit-dir=${placeholder "out"}/lib/systemd/system"
    "-Ddemo-agent=${lib.boolToString withDemoAgent}"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Ddbus-srv-user=geoclue"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-D3g-source=false"
    "-Dcdma-source=false"
    "-Dmodem-gps-source=false"
    "-Dnmea-source=false"
  ];

  postPatch = ''
    chmod +x demo/install-file.py
    patchShebangs demo/install-file.py
  '';

  passthru = {
    tests = {
      inherit (nixosTests) geoclue2;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin && withDemoAgent;
    description = "Geolocation framework and some data providers";
    homepage = "https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home";
    changelog = "https://gitlab.freedesktop.org/geoclue/geoclue/-/blob/${finalAttrs.version}/NEWS";
    maintainers = with maintainers; [
      raskin
      mimame
    ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2Plus;
  };
})
