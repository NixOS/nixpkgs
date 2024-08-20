{ lib, stdenv
, fetchurl
# native
, meson
, ninja
, pkg-config
, gettext
, desktop-file-utils
, appstream-glib
, wrapGAppsHook4
, python3
# Not native
, gst_all_1
, gsettings-desktop-schemas
, gtk4
, avahi
, glib
, networkmanager
, json-glib
, libadwaita
, libportal-gtk4
, libpulseaudio
, libsoup_3
, pipewire
, protobufc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-network-displays";
  version = "0.92.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-network-displays/${lib.versions.majorMinor finalAttrs.version}/gnome-network-displays-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-df35UJnRolVSiYcArpnrglxNKbTKA3LAGsNwlDF7cj4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
    python3
  ];

  buildInputs = [
    avahi
    gtk4
    glib
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-rtsp-server
    gst_all_1.gst-vaapi
    pipewire
    networkmanager
    json-glib
    libadwaita
    libportal-gtk4
    libpulseaudio
    libsoup_3
    protobufc
  ];

  /* Without this flag, we get this include error:

  /nix/store/...-gst-rtsp-server-1.22.8-dev/include/gstreamer-1.0/gst/rtsp-server/rtsp-media-factory.h:21:10: fatal error: gst/rtsp/gstrtspurl.h: No such file or directory
  21 | #include <gst/rtsp/gstrtspurl.h>

  Hence, this is not necessarily an upstream issue, but could be something
  wrong with how our gst_all_1 depend on each other.
  */
  CFLAGS = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  preConfigure = ''
    patchShebangs ./build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-network-displays";
    description = "Miracast implementation for GNOME";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "gnome-network-displays";
  };
})
