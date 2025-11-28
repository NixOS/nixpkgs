{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  adwaita-icon-theme,
  gtk3,
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
  gcr,
  libgee,
  gexiv2,
  gettext,
  desktop-file-utils,
  gdk-pixbuf,
  librsvg,
  wrapGAppsHook3,
  gobject-introspection,
  itstool,
  libsecret,
  libportal-gtk3,
  gsettings-desktop-schemas,
  libheif,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shotwell";
  version = "0.32.14";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/${lib.versions.majorMinor finalAttrs.version}/shotwell-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-QbEi9V0kWkto1ocIX9kjmNJfC7ylSDqYsreTK+Tyido=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    itstool
    gettext
    desktop-file-utils
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
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
    gcr
    adwaita-icon-theme
    libsecret
    libportal-gtk3
  ];

  postInstall = ''
    # Pull in HEIF support.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          libheif.lib
        ];
      }
    }"
  '';

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
