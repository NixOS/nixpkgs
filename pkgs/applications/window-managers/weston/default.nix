{ lib, stdenv, fetchurl, fetchpatch2
, meson, ninja, pkg-config, python3, wayland-scanner
, cairo, libdrm, libevdev, libinput, libxkbcommon, mesa, seatd, wayland
, wayland-protocols, xcbutilcursor

, demoSupport ? true
, hdrSupport ? true, libdisplay-info
, jpegSupport ? true, libjpeg
, lcmsSupport ? true, lcms2
, pangoSupport ? true, pango
, pipewireSupport ? true, pipewire
, rdpSupport ? true, freerdp
, remotingSupport ? true, gst_all_1
, vaapiSupport ? true, libva
, vncSupport ? true, aml, neatvnc, pam
, webpSupport ? true, libwebp
, xwaylandSupport ? true, libXcursor, xwayland
}:

stdenv.mkDerivation rec {
  pname = "weston";
  version = "12.0.2";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/weston/-/releases/${version}/downloads/weston-${version}.tar.xz";
    hash = "sha256-62hqfPAJkqI7F/GS/KmohzE+ksNG7jXYV1GWmD1la0o=";
  };

  patches = [
    # ci, backend-vnc: update to Neat VNC 0.7.0
    # part of https://gitlab.freedesktop.org/wayland/weston/-/merge_requests/1051
    (fetchpatch2 {
      url = "https://gitlab.freedesktop.org/wayland/weston/-/commit/8895b15f3dfc555a869e310ff6e16ff5dced1336.patch";
      hash = "sha256-PGAmQhzG8gZcYRaZwhKPlgzfbILIXGAHLSd9dCHAP1A=";
      excludes = [ ".gitlab-ci.yml" ];
    })
  ];

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config python3 wayland-scanner ];
  buildInputs = [
    cairo libdrm libevdev libinput libxkbcommon mesa seatd wayland
    wayland-protocols
  ] ++ lib.optional hdrSupport libdisplay-info
    ++ lib.optional jpegSupport libjpeg
    ++ lib.optional lcmsSupport lcms2
    ++ lib.optional pangoSupport pango
    ++ lib.optional pipewireSupport pipewire
    ++ lib.optional rdpSupport freerdp
    ++ lib.optionals remotingSupport [ gst_all_1.gstreamer gst_all_1.gst-plugins-base ]
    ++ lib.optional vaapiSupport libva
    ++ lib.optionals vncSupport [ aml neatvnc pam ]
    ++ lib.optional webpSupport libwebp
    ++ lib.optionals xwaylandSupport [ libXcursor xcbutilcursor xwayland ];

  mesonFlags= [
    (lib.mesonBool "backend-drm-screencast-vaapi" vaapiSupport)
    (lib.mesonBool "backend-pipewire" pipewireSupport)
    (lib.mesonBool "backend-rdp" rdpSupport)
    (lib.mesonBool "backend-vnc" vncSupport)
    (lib.mesonBool "color-management-lcms" lcmsSupport)
    (lib.mesonBool "demo-clients" demoSupport)
    (lib.mesonBool "image-jpeg" jpegSupport)
    (lib.mesonBool "image-webp" webpSupport)
    (lib.mesonBool "pipewire" pipewireSupport)
    (lib.mesonBool "remoting" remotingSupport)
    (lib.mesonOption "simple-clients" "")
    (lib.mesonBool "test-junit-xml" false)
    (lib.mesonBool "xwayland" xwaylandSupport)
  ] ++ lib.optionals xwaylandSupport [
    (lib.mesonOption "xwayland-path" (lib.getExe xwayland))
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
    mainProgram = "weston";
    maintainers = with maintainers; [ primeos qyliss ];
  };
}
