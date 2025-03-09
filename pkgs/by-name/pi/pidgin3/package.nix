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
  libadwaita,
  libxml2,
  json-glib,
  libsoup_3,
  sqlite,
  libsecret,
  birb,
  xeme,
  gplugin,
  hasl,
  ibis,
  glib-networking,
  gst_all_1,
  darwin,
}:

stdenv.mkDerivation {
  pname = "pidgin3";
  version = "0-unstable-2024-10-18";

  src = fetchhg {
    url = "https://keep.imfreedom.org/pidgin/pidgin";
    rev = "7621ef6ea06a";
    hash = "sha256-PgfmcIeeZzvujmyCr/g0t5Ml/2cc9e0w72RPAUVggEk=";
  };

  postPatch = ''
    patchShebangs --build mkmesonconf.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libxml2
    json-glib
    libsoup_3
    sqlite
    libsecret
    birb
    xeme
    gplugin
    hasl
    ibis
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  mesonFlags = [
    # Haven't figured out how to make kwallet discoverable to meson
    (lib.mesonEnable "kwallet" false)
  ];

  meta = {
    description = "Multi-protocol instant messaging client, 3rd version in development";
    homepage = "https://pidgin.im";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pidgin3";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
