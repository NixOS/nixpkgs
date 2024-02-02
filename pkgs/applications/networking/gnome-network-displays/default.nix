{ lib, stdenv
, fetchurl
, fetchpatch
# native
, meson
, ninja
, pkg-config
, gettext
, desktop-file-utils
, appstream-glib
, wrapGAppsHook
, python3
# Not native
, gst_all_1
, gsettings-desktop-schemas
, gtk3
, glib
, networkmanager
, libpulseaudio
, pipewire
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-network-displays";
  version = "0.90.5";

  src = fetchurl {
    url = "mirror://gnome/sources/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-2SBVQK4fJeK8Y2UrrL0g5vQIerDdGE1nhFc6ke4oIpI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream-glib
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
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
    libpulseaudio
  ];

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
