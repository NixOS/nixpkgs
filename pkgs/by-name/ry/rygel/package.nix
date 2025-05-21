{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, vala
, gettext
, libxml2
, gobject-introspection
, wrapGAppsHook3
, python3
, glib
, gssdp_1_6
, gupnp_1_6
, gupnp-av
, gupnp-dlna
, gst_all_1
, libgee
, libsoup_3
, gtk3
, libmediaart
, sqlite
, systemd
, tracker
, shared-mime-info
, gnome
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rygel";
  version = "0.42.6";

  # TODO: split out lib
  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/rygel/${lib.versions.majorMinor finalAttrs.version}/rygel-${finalAttrs.version}.tar.xz";
    hash = "sha256-R9JXBLYQiDdeJqq6Vr5HwXGJRy5vgMdSq+hvAu9OMwQ=";
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
    gssdp_1_6
    gupnp_1_6
    gupnp-av
    gupnp-dlna
    libgee
    libsoup_3
    gtk3
    libmediaart
    sqlite
    systemd
    tracker
    shared-mime-info
  ] ++ (with gst_all_1; [
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
      packageName = "rygel";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Home media solution (UPnP AV MediaServer) that allows you to easily share audio, video and pictures to other devices";
    homepage = "https://gitlab.gnome.org/GNOME/rygel";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
