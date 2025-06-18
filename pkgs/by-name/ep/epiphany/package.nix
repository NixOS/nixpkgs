{
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  fetchurl,
  fetchpatch,
  pkg-config,
  gtk4,
  glib,
  icu,
  wrapGAppsHook4,
  gnome,
  libportal-gtk4,
  libxml2,
  itstool,
  webkitgtk_6_0,
  libsoup_3,
  glib-networking,
  libsecret,
  gnome-desktop,
  libarchive,
  p11-kit,
  sqlite,
  gcr_4,
  isocodes,
  desktop-file-utils,
  nettle,
  gdk-pixbuf,
  gst_all_1,
  json-glib,
  libadwaita,
  buildPackages,
  withPantheon ? false,
  pantheon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epiphany";
  version = "48.3";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/${lib.versions.major finalAttrs.version}/epiphany-${finalAttrs.version}.tar.xz";
    hash = "sha256-2ilT5+K3O/dHPAozl5EE15NieVKV6qCio46hiFN9rxM=";
  };

  patches = [
    # shell: Fix startup crash on Pantheon
    # https://gitlab.gnome.org/GNOME/epiphany/-/merge_requests/1818
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/epiphany/-/commit/da4437beb7f1fbc9c2fa3d4629b8c826d484835e.patch";
      hash = "sha256-meufd5gnhLcK0dgIXEMDnid9e1R2M1D3jZ9Yoh6YobM=";
    })

    # action-bar-end: Fix startup crash on Pantheon
    # https://gitlab.gnome.org/GNOME/epiphany/-/merge_requests/1819
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/epiphany/-/commit/d69866854b315123c8832fae58c6de008da20ea0.patch";
      hash = "sha256-GnZQC4rtBYRr+x9mF8pCFDcDOjEJj+27ECdXBNL42kQ=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    buildPackages.glib
    buildPackages.gtk4
  ];

  buildInputs =
    [
      gcr_4
      gdk-pixbuf
      glib
      glib-networking
      gnome-desktop
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gtk4
      icu
      isocodes
      json-glib
      libadwaita
      libportal-gtk4
      libarchive
      libsecret
      libsoup_3
      libxml2
      nettle
      p11-kit
      sqlite
      webkitgtk_6_0
    ]
    ++ lib.optionals withPantheon [
      pantheon.granite7
    ];

  # Tests need an X display
  mesonFlags =
    [
      "-Dunit_tests=disabled"
    ]
    ++ lib.optionals withPantheon [
      "-Dgranite=enabled"
    ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "epiphany";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Epiphany/";
    description = "WebKit based web browser for GNOME";
    mainProgram = "epiphany";
    teams = [
      teams.gnome
      teams.pantheon
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
