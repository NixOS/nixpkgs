{ stdenv, fetchurl, pkgconfig, wayland, mesa, libxkbcommon, cairo, libxcb
, libXcursor, xlibsWrapper, udev, libdrm, mtdev, libjpeg, pam, dbus, libinput
, pango ? null, libunwind ? null, freerdp ? null, vaapi ? null, libva ? null
, libwebp ? null, xwayland ? null, wayland-protocols
# beware of null defaults, as the parameters *are* supplied by callPackage by default
}:

stdenv.mkDerivation rec {
  name = "weston-${version}";
  version = "1.12.0";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "ac7ac2a32e3b9f50131fccded5d2326bd36b2226712d90b61999118a09af5033";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    wayland mesa libxkbcommon cairo libxcb libXcursor xlibsWrapper udev libdrm
    mtdev libjpeg pam dbus libinput pango libunwind freerdp vaapi libva
    libwebp wayland-protocols
  ];

  configureFlags = [
    "--enable-x11-compositor"
    "--enable-drm-compositor"
    "--enable-wayland-compositor"
    "--enable-headless-compositor"
    "--enable-fbdev-compositor"
    "--enable-screen-sharing"
    "--enable-clients"
    "--enable-weston-launch"
    "--disable-setuid-install" # prevent install target to chown root weston-launch, which fails
  ] ++ stdenv.lib.optional (freerdp != null) "--enable-rdp-compositor"
    ++ stdenv.lib.optional (vaapi != null) "--enabe-vaapi-recorder"
    ++ stdenv.lib.optionals (xwayland != null) [
        "--enable-xwayland"
        "--with-xserver-path=${xwayland.out}/bin/Xwayland"
      ];

  meta = with stdenv.lib; {
    description = "Reference implementation of a Wayland compositor";
    homepage = http://wayland.freedesktop.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
