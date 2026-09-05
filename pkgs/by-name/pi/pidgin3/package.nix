{
  lib,
  stdenv,
  fetchhg,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  python3,
  wrapGAppsHook4,
  cmake,
  libadwaita,
  libxml2,
  json-glib,
  libsoup_3,
  libsecret,
  sqlite,
  birb,
  seagull,
  xeme,
  gplugin,
  hasl,
  ibis,
  glib-networking,
  gi-docgen,
  libspelling,
  gst_all_1,
  enableKwalletSupport ? stdenv.hostPlatform.isLinux,
  kdePackages,
  # https://keep.imfreedom.org/pidgin/pidgin/file/tip/meson_options.txt
  # See 'Protocol Plugins' for a list of plugins
  enableSipPlugin ? false,
  sofia_sip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pidgin3";
  version = "2.92.1";

  src = fetchhg {
    url = "https://keep.imfreedom.org/pidgin/pidgin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xP4aEPnJVxnNMbjjjsXZuuVYQPCDAgcvGgKn5nn8M60=";
  };

  postPatch = ''
    patchShebangs --build mkmesonconf.py
    patchShebangs --build scripts/check_license_header.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    python3
    wrapGAppsHook4
  ]
  ++ lib.optionals enableKwalletSupport [
    cmake
  ];

  buildInputs = [
    libadwaita
    libxml2
    json-glib
    libsoup_3
    libsecret
    sqlite
    birb
    seagull
    xeme
    gplugin
    hasl
    ibis
    glib-networking
    gi-docgen
    libspelling
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ]
  ++ lib.optionals enableKwalletSupport [
    kdePackages.kwallet
  ]
  ++ lib.optionals enableSipPlugin [
    sofia_sip
  ];

  mesonFlags = [
    # Haven't figured out how to make kwallet discoverable to meson
    (lib.mesonEnable "kwallet" enableKwalletSupport)
    (lib.mesonEnable "libsecret" true)
    (lib.mesonBool "doc" true)
    (lib.mesonEnable "sip" enableSipPlugin)
  ];

  dontWrapQtApps = true;

  doCheck = true;

  meta = {
    description = "Multi-protocol instant messaging client, 3rd version in development";
    homepage = "https://pidgin.im";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pidgin3";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
