{ stdenv, fetchurl, meson, ninja, pkgconfig
, wayland, libGL, mesa, libxkbcommon, cairo, libxcb
, libXcursor, xlibsWrapper, udev, libdrm, mtdev, libjpeg, pam, dbus, libinput, libevdev
, colord, lcms2, pipewire ? null
, pango ? null, libunwind ? null, freerdp ? null, vaapi ? null, libva ? null
, libwebp ? null, xwayland ? null, wayland-protocols
# beware of null defaults, as the parameters *are* supplied by callPackage by default
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "weston";
  version = "8.0.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0j3q0af3595g4wcicldgy749zm2g2b6bswa6ya8k075a5sdv863m";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    wayland libGL mesa libxkbcommon cairo libxcb libXcursor xlibsWrapper udev libdrm
    mtdev libjpeg pam dbus libinput libevdev pango libunwind freerdp vaapi libva
    libwebp wayland-protocols
    colord lcms2 pipewire
  ];

  mesonFlags= [
    "-Dbackend-drm-screencast-vaapi=${boolToString (vaapi != null)}"
    "-Dbackend-rdp=${boolToString (freerdp != null)}"
    "-Dxwayland=${boolToString (xwayland != null)}" # Default is true!
    "-Dremoting=false" # TODO
    "-Dpipewire=${boolToString (pipewire != null)}"
    "-Dimage-webp=${boolToString (libwebp != null)}"
    "-Ddemo-clients=false"
    "-Dsimple-clients="
    "-Dtest-junit-xml=false"
    # TODO:
    #"--enable-clients"
    #"--disable-setuid-install" # prevent install target to chown root weston-launch, which fails
  ] ++ optionals (xwayland != null) [
    "-Dxwayland-path=${xwayland.out}/bin/Xwayland"
  ];

  passthru.providedSessions = [ "weston" ];

  meta = {
    description = "Reference implementation of a Wayland compositor";
    homepage = https://wayland.freedesktop.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
