{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  glib-networking,
  gtk3,
  libsoup_3,
  keybinder3,
  gst_all_1,
  wrapGAppsHook3,
  appstream-glib,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goodvibes";
  version = "0.8.3";

  src = fetchFromGitLab {
    owner = "goodvibes";
    repo = "goodvibes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lh4FPH0Bdxg2J4IxsZPs8Zjc7Tcobb4bTpvJzVNIy0Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    # for libsoup TLS support
    glib-networking
    gtk3
    libsoup_3
    keybinder3
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  postPatch = ''
    patchShebangs scripts
  '';

  meta = {
    description = "Lightweight internet radio player";
    homepage = "https://gitlab.com/goodvibes/goodvibes";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
