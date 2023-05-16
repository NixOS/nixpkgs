{ lib, stdenv, fetchurl
, meson, ninja, pkg-config, python3, wayland-scanner
<<<<<<< HEAD
, cairo, dbus, libdrm, libevdev, libinput, libxkbcommon, mesa, seatd, wayland
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
=======
, cairo, colord, dbus, lcms2, libGL, libXcursor, libdrm, libevdev, libinput
, libjpeg, seatd, libxcb, libxkbcommon, mesa, mtdev, pam, udev, wayland
, wayland-protocols
, pipewire ? null, pango ? null, libunwind ? null, freerdp ? null, vaapi ? null
, libva ? null, libwebp ? null, xwayland ? null
# beware of null defaults, as the parameters *are* supplied by callPackage by default
, buildDemo ? true
, buildRemoting ? true, gst_all_1
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "weston";
<<<<<<< HEAD
  version = "12.0.2";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/weston/-/releases/${version}/downloads/weston-${version}.tar.xz";
    hash = "sha256-62hqfPAJkqI7F/GS/KmohzE+ksNG7jXYV1GWmD1la0o=";
=======
  version = "11.0.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/weston/uploads/f5648c818fba5432edc3ea63c4db4813/weston-${version}.tar.xz";
    sha256 = "sha256-pBP2jCUpV/wxkcNlCCPsNWrowSTMwMtEDaXNxOLLnlc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config python3 wayland-scanner ];
  buildInputs = [
<<<<<<< HEAD
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
=======
    cairo colord dbus freerdp lcms2 libGL libXcursor libdrm libevdev libinput
    libjpeg seatd libunwind libva libwebp libxcb libxkbcommon mesa mtdev pam
    pango pipewire udev vaapi wayland wayland-protocols
  ] ++ lib.optionals buildRemoting [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  mesonFlags= [
    "-Dbackend-drm-screencast-vaapi=${lib.boolToString (vaapi != null)}"
    "-Dbackend-rdp=${lib.boolToString (freerdp != null)}"
    "-Dxwayland=${lib.boolToString (xwayland != null)}" # Default is true!
    (lib.mesonBool "remoting" buildRemoting)
    "-Dpipewire=${lib.boolToString (pipewire != null)}"
    "-Dimage-webp=${lib.boolToString (libwebp != null)}"
    (lib.mesonBool "demo-clients" buildDemo)
    "-Dsimple-clients="
    "-Dtest-junit-xml=false"
  ] ++ lib.optionals (xwayland != null) [
    "-Dxwayland-path=${xwayland.out}/bin/Xwayland"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ primeos qyliss ];
=======
    maintainers = with maintainers; [ primeos ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
