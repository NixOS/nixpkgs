{
  lib,
  stdenv,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  libadwaita,
  libsecret,
  mobile-broadband-provider-info,
  modemmanager,
  gmobile,
  gnome,
  gtk4,
  gom,
  gsound,
  feedbackd,
  callaudiod,
  evolution-data-server-gtk4,
  folks,
  desktop-file-utils,
  appstream,
  libpeas2,
  dbus,
  vala,
  wrapGAppsHook4,
  xvfb-run,
  gtk-doc,
  bubblewrap,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  docutils,
  gst_all_1,
  shared-mime-info,
  sofia_sip,
  writeShellScriptBin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calls";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/calls/${lib.versions.major finalAttrs.version}/calls-${finalAttrs.version}.tar.xz";
    hash = "sha256-8ozMjm+8UHnnuLXRGlUZabtw2QXl7ZDRsdho8SBFxy8=";
  };

  outputs = [
    "out"
    "devdoc"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream
    vala
    wrapGAppsHook4
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    docutils
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    modemmanager
    libadwaita
    libsecret
    mobile-broadband-provider-info
    gmobile
    evolution-data-server-gtk4 # UI part not needed, using gtk4 variant (over the default of gtk3) to reduce closure.
    folks
    gom
    gsound
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    feedbackd
    callaudiod
    gtk4
    libpeas2
    sofia_sip
  ];

  nativeCheckInputs = [
    (writeShellScriptBin "dbus-run-session" ''
      # tests invoke `dbus-run-session` directly, but without the necessary `--config-file` argument
      exec ${lib.getExe' dbus "dbus-run-session"} --config-file=${dbus}/share/dbus-1/session.conf "$@"
    '')
    bubblewrap
    dbus
    shared-mime-info
    xvfb-run
  ];

  mesonFlags = [
    (lib.mesonBool "gtk_doc" true)
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  strictDeps = true;
  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  checkPhase = ''
    runHook preCheck

    HOME=$(mktemp -d) \
    xvfb-run -s '-screen 0 800x600x24' \
      bwrap --unshare-uts --hostname 127.0.0.1 --dev-bind / / \
      meson test --no-rebuild --print-errorlogs

    runHook postCheck
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "calls";
    };
  };

  meta = {
    description = "Phone dialer and call handler";
    longDescription = "GNOME Calls is a phone dialer and call handler. Setting NixOS option `programs.calls.enable = true` is recommended.";
    homepage = "https://gitlab.gnome.org/GNOME/calls";
    changelog = "https://gitlab.gnome.org/GNOME/calls/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ craigem ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
    mainProgram = "gnome-calls";
  };
})
