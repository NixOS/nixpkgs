{ lib, stdenv, fetchurl, cmake, meson, ninja, pkg-config
, cairo, doctest, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, wayland
, wayland-protocols, wf-config, wlroots, mesa, pango
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.7.4";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire/releases/download/v${version}/wayfire-${version}.tar.xz";
    sha256 = "sha256-ieN19zINe9QCPZ+Umfl57nIJWUr7taoM/Yl5NKfwUU0=";
  };


  nativeBuildInputs = [ cmake meson ninja pkg-config wayland ];
  buildInputs = [
    cairo doctest libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config mesa pango
  ];
  propagatedBuildInputs = [ wlroots ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  mesonFlags = [ "--sysconfdir" "/etc" ];

  meta = with lib; {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
    changelog = "https://github.com/WayfireWM/wayfire/releases/tag/${version}";
  };
}
