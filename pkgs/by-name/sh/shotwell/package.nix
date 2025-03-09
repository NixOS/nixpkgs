{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  gtk4,
  libexif,
  libgphoto2,
  libwebp,
  libsoup_3,
  libxml2,
  vala,
  sqlite,
  pkg-config,
  gnome,
  gst_all_1,
  libgudev,
  libraw,
  glib,
  glib-networking,
  json-glib,
  gcr_4,
  libgee,
  gexiv2,
  librest,
  gettext,
  desktop-file-utils,
  gdk-pixbuf,
  librsvg,
  wrapGAppsHook4,
  gobject-introspection,
  itstool,
  libsecret,
  libportal-gtk4,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shotwell";
  version = "33.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/${lib.versions.majorMinor finalAttrs.version}/shotwell-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-VoVbAkUGc01DWZQ6EzE+FRJMXXoJr/xsdMX7pIKj5po=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    itstool
    gettext
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libexif
    libgphoto2
    libwebp
    libsoup_3
    libxml2
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libgee
    libgudev
    gexiv2
    gsettings-desktop-schemas
    libraw
    json-glib
    glib
    glib-networking
    gdk-pixbuf
    librsvg
    librest
    gcr_4
    libsecret
    libportal-gtk4
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "shotwell";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Popular photo organizer for the GNOME desktop";
    mainProgram = "shotwell";
    homepage = "https://gitlab.gnome.org/GNOME/shotwell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.linux;
  };
})
