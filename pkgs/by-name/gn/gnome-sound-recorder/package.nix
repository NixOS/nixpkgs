{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gettext,
  gobject-introspection,
  wrapGAppsHook4,
  gjs,
  glib,
  gtk4,
  gdk-pixbuf,
  gst_all_1,
  gnome,
  meson,
  ninja,
  python3,
  desktop-file-utils,
  libadwaita,
}:

stdenv.mkDerivation rec {
  pname = "gnome-sound-recorder";
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sound-recorder/${lib.versions.major version}/gnome-sound-recorder-${version}.tar.xz";
    hash = "sha256-bbbbmjsbUv0KtU+aW/Tymctx5SoTrF/fw+dOtGmFpOY=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    ninja
    gobject-introspection
    wrapGAppsHook4
    python3
    desktop-file-utils
  ];

  buildInputs = [
    gjs
    glib
    gtk4
    gdk-pixbuf
    libadwaita
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad # for gstreamer-player-1.0
  ]);

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    substituteInPlace build-aux/meson_post_install.py \
      --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-sound-recorder"; };
  };

  meta = {
    description = "Simple and modern sound recorder";
    mainProgram = "gnome-sound-recorder";
    homepage = "https://gitlab.gnome.org/World/vocalis";
    changelog = "https://gitlab.gnome.org/World/vocalis/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
}
