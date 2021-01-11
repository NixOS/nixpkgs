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
}:

stdenv.mkDerivation rec {
  pname = "gnome-network-displays";
  version = "0.90.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "04snnfz5jxxpjkrwa7dchc2h4shszi8mq9g3ihvsvipgzjw3d498";
  };

  patches = [
    # Undeclared dependency on gio-unix-2.0, see:
    # https://github.com/NixOS/nixpkgs/issues/36468 and
    # https://gitlab.gnome.org/GNOME/gnome-network-displays/-/merge_requests/147
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-network-displays/-/commit/ef3f3ff565acd8238da46de604a1e750d4f02f07.diff";
      sha256 = "1ljiwgqia6am4lansg70qnwkch9mp1fr6bga98s5fwyiaw6b6f4p";
    })
    # Fixes an upstream bug: https://gitlab.gnome.org/GNOME/gnome-network-displays/-/issues/147
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-network-displays/-/commit/23164b58f4d5dd59de988525906d6e5e82c5a63c.patch";
      sha256 = "0x32dvkzv9m04q41aicscpf4aspghx81a65462kjqnsavi64lga5";
    })
  ];

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
  };
}
