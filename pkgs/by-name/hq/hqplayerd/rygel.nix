{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  libxml2,
  gobject-introspection,
  wrapGAppsHook3,
  python3,
  glib,
  gssdp,
  gupnp,
  gupnp-av,
  gupnp-dlna,
  gst_all_1,
  libgee,
  libsoup_2_4,
  gtk3,
  libmediaart,
  sqlite,
  systemd,
  tinysparql,
  shared-mime-info,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "rygel";
  version = "0.40.4";

  # TODO: split out lib
  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "c22K2+hhX2y8j8//mEXcmF/RDhZinaI2tLUtvt8KNIs=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    libxml2
    gobject-introspection
    wrapGAppsHook3
    python3
  ];

  buildInputs = [
    glib
    gssdp
    gupnp
    gupnp-av
    gupnp-dlna
    libgee
    libsoup_2_4
    gtk3
    libmediaart
    sqlite
    systemd
    tinysparql
    shared-mime-info
  ]
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
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs data/xml/process-xml.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Home media solution (UPnP AV MediaServer) that allows you to easily share audio, video and pictures to other devices";
    homepage = "https://gitlab.gnome.org/GNOME/rygel";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
}
