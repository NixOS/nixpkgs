{ lib, stdenv, fetchurl
, meson, ninja, pkg-config, python3, wayland-scanner
, cairo, dbus, lcms2, libdrm, libevdev, libinput, libjpeg, libxkbcommon, mesa
, seatd, wayland, wayland-protocols

, demoSupport ? true
, pangoSupport ? true, pango
, pipewireSupport ? true, pipewire
, rdpSupport ? true, freerdp
, remotingSupport ? true, gst_all_1
, vaapiSupport ? true, libva
, webpSupport ? true, libwebp
, xwaylandSupport ? true, libXcursor, xwayland
}:

stdenv.mkDerivation rec {
  pname = "weston";
  version = "11.0.2";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/weston/-/releases/${version}/downloads/weston-${version}.tar.xz";
    hash = "sha256-ckB1LO8LfeYiuvi9U0jmP8axnwLvgklhsq3Rd9llKVI=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config python3 wayland-scanner ];
  buildInputs = [
    cairo dbus lcms2 libdrm libevdev libinput libjpeg libxkbcommon mesa seatd
    wayland wayland-protocols
  ] ++ lib.optional pangoSupport pango
    ++ lib.optional pipewireSupport pipewire
    ++ lib.optional rdpSupport freerdp
    ++ lib.optionals remotingSupport [ gst_all_1.gstreamer gst_all_1.gst-plugins-base ]
    ++ lib.optional vaapiSupport libva
    ++ lib.optional webpSupport libwebp
    ++ lib.optionals xwaylandSupport [ libXcursor xwayland ];

  mesonFlags= [
    (lib.mesonBool "backend-drm-screencast-vaapi" vaapiSupport)
    (lib.mesonBool "backend-rdp" rdpSupport)
    (lib.mesonBool "demo-clients" demoSupport)
    (lib.mesonBool "image-webp" webpSupport)
    (lib.mesonBool "pipewire" pipewireSupport)
    (lib.mesonBool "remoting" remotingSupport)
    (lib.mesonOption "simple-clients" "")
    (lib.mesonBool "test-junit-xml" false)
    (lib.mesonBool "xwayland" xwaylandSupport)
  ] ++ lib.optionals xwaylandSupport [
    (lib.mesonOption "xwayland-path" "${xwayland.out}/bin/Xwayland")
  ];

  passthru.providedSessions = [ "weston" ];

  meta = with lib; {
    description = "A lightweight and functional Wayland compositor";
    longDescription = ''
      Weston is the reference implementation of a Wayland compositor, as well
      as a useful environment in and of itself.
      Out of the box, Weston provides a very basic desktop, or a full-featured
      environment for non-desktop uses such as automotive, embedded, in-flight,
      industrial, kiosks, set-top boxes and TVs. It also provides a library
      allowing other projects to build their own full-featured environments on
      top of Weston's core. A small suite of example or demo clients are also
      provided.
    '';
    homepage = "https://gitlab.freedesktop.org/wayland/weston";
    license = licenses.mit; # Expat version
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
