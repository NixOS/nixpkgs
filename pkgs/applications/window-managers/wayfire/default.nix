{ stdenv, fetchFromGitHub
, meson, pkg-config, ninja
, wayland, wayland-protocols
, cairo, glm, wlroots
, libevdev, freetype, libinput
, pixman, libxkbcommon, libdrm
, libjpeg, libpng, libav
, libGL, mesa, wf-config
, libcap, xcbutilerrors, xcbutilwm, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "ee9c9d708065f6b17df4fa454e6741bed10899d4";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = version;
    sha256 = "sha256-zKaZr/tBTeMUeqgxSLKe+/rW+JGon+MzBzP3mnZh96E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    wayland wayland-protocols
    cairo glm libav wlroots
    libevdev freetype libinput
    pixman libxkbcommon libdrm
    libjpeg libpng
    libGL mesa wf-config
    libcap xcbutilerrors xcbutilwm libxml2
  ];
  mesonFlags = [
    "-Duse_system_wlroots=enabled"
    "-Duse_system_wfconfig=enabled"
    "-Dwlroots:logind-provider=systemd"
    "-Dwlroots:libseat=disabled"
  ];

  meta = with stdenv.lib; {
    description = "3D wayland compositor";
    homepage    = "https://wayfire.org/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ishan ];
  };
}
