{
  stdenv,
  lib,
  fetchurl,
  docbook-xsl-nons,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  libxml2,
  libxslt,
  gobject-introspection,
  wrapGAppsHook4,
  wrapGAppsNoGuiHook,
  python3,
  gdk-pixbuf,
  glib,
  gssdp_1_6,
  gupnp_1_6,
  gupnp-av,
  gupnp-dlna,
  gst_all_1,
  libgee,
  libsoup_3,
  libX11,
  withGtk ? true,
  gtk4,
  libmediaart,
  pipewire,
  sqlite,
  systemd,
  tinysparql,
  shared-mime-info,
  gnome,
  rygel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rygel";
  version = "45.0";

  # TODO: split out lib
  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/rygel/${lib.versions.major finalAttrs.version}/rygel-${finalAttrs.version}.tar.xz";
    hash = "sha256-gmZ7kC/AZy5kz5HrcnpwE3qP3+ej2aTBWLD0sfxwCII=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    meson
    ninja
    pkg-config
    vala
    gettext
    libxml2
    libxslt # for xsltproc
    gobject-introspection
    (if withGtk then wrapGAppsHook4 else wrapGAppsNoGuiHook)
    python3
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gssdp_1_6
    gupnp_1_6
    gupnp-av
    gupnp-dlna
    libgee
    libsoup_3
    libmediaart
    pipewire
    # Move this to withGtk when it's not unconditionally included
    # https://gitlab.gnome.org/GNOME/rygel/-/issues/221
    # https://gitlab.gnome.org/GNOME/rygel/-/merge_requests/27
    libX11
    sqlite
    systemd
    tinysparql
    shared-mime-info
  ]
  ++ lib.optionals withGtk [ gtk4 ]
  ++ (with gst_all_1; [
    gstreamer
    gst-editing-services
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  mesonFlags = [
    "-Dsystemd-user-units-dir=${placeholder "out"}/lib/systemd/user"
    "-Dapi-docs=false"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    (lib.mesonEnable "gtk" withGtk)
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs data/xml/process-xml.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "rygel";
      versionPolicy = "odd-unstable";
    };
    noGtk = rygel.override { withGtk = false; };
  };

  meta = with lib; {
    description = "Home media solution (UPnP AV MediaServer) that allows you to easily share audio, video and pictures to other devices";
    homepage = "https://gitlab.gnome.org/GNOME/rygel";
    changelog = "https://gitlab.gnome.org/GNOME/rygel/-/blob/rygel-${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})
