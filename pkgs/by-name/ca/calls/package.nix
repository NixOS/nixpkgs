{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  libadwaita,
  libsecret,
  modemmanager,
  gtk4,
  gom,
  gsound,
  feedbackd,
  callaudiod,
  evolution-data-server-gtk4,
  folks,
  desktop-file-utils,
  appstream-glib,
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
  version = "49.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "calls";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-fqvfzdk1szNFm4aRRGNDaA/AmjJdQjBsMhvEolEetE0=";
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
    appstream-glib
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

  meta = with lib; {
    description = "Phone dialer and call handler";
    longDescription = "GNOME Calls is a phone dialer and call handler. Setting NixOS option `programs.calls.enable = true` is recommended.";
    homepage = "https://gitlab.gnome.org/GNOME/calls";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ craigem ];
    platforms = platforms.linux;
    mainProgram = "gnome-calls";
  };
})
