{ stdenv, fetchurl, meson, ninja, pkgconfig
, wayland, libGL, mesa, libxkbcommon, cairo, libxcb
, libXcursor, xlibsWrapper, udev, libdrm, mtdev, libjpeg, pam, dbus, libinput, libevdev
, colord, lcms2
, pango ? null, libunwind ? null, freerdp ? null, vaapi ? null, libva ? null
, libwebp ? null, xwayland ? null, wayland-protocols
# beware of null defaults, as the parameters *are* supplied by callPackage by default
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "weston";
  version = "6.0.1";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1d2m658ll8x7prlsfk71qgw89c7dz6y7d6nndfxwl49fmrd6sbxz";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    wayland libGL mesa libxkbcommon cairo libxcb libXcursor xlibsWrapper udev libdrm
    mtdev libjpeg pam dbus libinput libevdev pango libunwind freerdp vaapi libva
    libwebp wayland-protocols
    colord lcms2
  ];

  mesonFlags= [
    "-Dbackend-drm-screencast-vaapi=${boolToString (vaapi != null)}"
    "-Dbackend-rdp=${boolToString (freerdp != null)}"
    "-Dxwayland=${boolToString (xwayland != null)}" # Default is true!
    "-Dremoting=false" # TODO
    "-Dimage-webp=${boolToString (libwebp != null)}"
    "-Dsimple-dmabuf-drm=" # Disables all drivers
    "-Ddemo-clients=false"
    "-Dsimple-clients="
    "-Dtest-junit-xml=false"
    # TODO:
    #"--enable-clients"
    #"--disable-setuid-install" # prevent install target to chown root weston-launch, which fails
  ] ++ optionals (xwayland != null) [
    "-Dxwayland-path=${xwayland.out}/bin/Xwayland"
  ];

  meta = {
    description = "Reference implementation of a Wayland compositor";
    homepage = https://wayland.freedesktop.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
