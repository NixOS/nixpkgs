{ stdenv, fetchFromGitHub
, meson, pkgconfig, ninja
, wayland, wayland-protocols
, cairo, glm
, libevdev, freetype, libinput
, pixman, libxkbcommon, libdrm
, libjpeg, libpng
, libGL, mesa
, libcap, xcbutilerrors, xcbutilwm, libxml2
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "8aa8260972edaba6d237e1a61217a4d2303edc3e";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = version;
    sha256 = "sha256-r9k8e0LCDxr8tEZvcBbkvZ2RqcKXYX+/fxalKoqT15U=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    # egl glesv2
    wayland wayland-protocols
    cairo glm
    libevdev freetype libinput
    pixman libxkbcommon libdrm
    libjpeg libpng
    libGL mesa
    libcap xcbutilerrors xcbutilwm libxml2
  ];
  mesonFlags = [
    "-Duse_system_wlroots=disabled"
    "-Duse_system_wfconfig=disabled"
    "-Dwlroots:logind-provider=systemd"
    "-Dwlroots:libseat=disabled"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "3D wayland compositor";
    homepage    = "https://wayfire.org/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ishan9299 ];
  };
}
