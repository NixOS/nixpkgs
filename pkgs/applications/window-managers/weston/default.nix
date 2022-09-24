{ lib, stdenv, fetchurl, fetchpatch
, meson, ninja, pkg-config, python3, wayland-scanner
, cairo, colord, dbus, lcms2, libGL, libXcursor, libdrm, libevdev, libinput
, libjpeg, libxcb, libxkbcommon, mesa, mtdev, pam, udev, wayland
, wayland-protocols, xlibsWrapper
, pipewire ? null, pango ? null, libunwind ? null, freerdp ? null, vaapi ? null
, libva ? null, libwebp ? null, xwayland ? null
# beware of null defaults, as the parameters *are* supplied by callPackage by default
}:

stdenv.mkDerivation rec {
  pname = "weston";
  version = "10.0.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/weston/-/releases/${version}/downloads/weston-${version}.tar.xz";
    sha256 = "05a10gfbadyxkwgsncc5vc343f493csgh10vk0878nl6d98557la";
  };

  patches = [
    # Fix race condition in build system
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/wayland/weston/-/commit/0d3e438d080433ed5d203c876e7de6c7f8a14f98.patch";
      sha256 = "sha256-d9NG1vUIuL4jpXqCo0myz/97JuFYesH+8kJnegQXeMU=";
    })
  ];

  nativeBuildInputs = [ meson ninja pkg-config python3 wayland-scanner ];
  buildInputs = [
    cairo colord dbus freerdp lcms2 libGL libXcursor libdrm libevdev libinput
    libjpeg libunwind libva libwebp libxcb libxkbcommon mesa mtdev pam pango
    pipewire udev vaapi wayland wayland-protocols xlibsWrapper
  ];

  mesonFlags= [
    "-Dbackend-drm-screencast-vaapi=${lib.boolToString (vaapi != null)}"
    "-Dbackend-rdp=${lib.boolToString (freerdp != null)}"
    "-Dxwayland=${lib.boolToString (xwayland != null)}" # Default is true!
    "-Dremoting=false" # TODO
    "-Dpipewire=${lib.boolToString (pipewire != null)}"
    "-Dimage-webp=${lib.boolToString (libwebp != null)}"
    "-Ddemo-clients=false"
    "-Dsimple-clients="
    "-Dtest-junit-xml=false"
    # TODO:
    #"--enable-clients"
    #"--disable-setuid-install" # prevent install target to chown root weston-launch, which fails
  ] ++ lib.optionals (xwayland != null) [
    "-Dxwayland-path=${xwayland.out}/bin/Xwayland"
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
