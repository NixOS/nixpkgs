{ lib, stdenv, fetchurl, cmake, meson, ninja, pkg-config
, cairo, doctest, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, wayland
, wayland-protocols, wf-config, wlroots, mesa, pango
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.7.3";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire/releases/download/v${version}/wayfire-${version}.tar.xz";
    sha256 = "sha256-mdHVGx24jDDeZIQJT9At85qCy7UDNh5Sq8HZT4NXy18=";
  };

  nativeBuildInputs = [ cmake meson ninja pkg-config wayland ];
  buildInputs = [
    cairo doctest libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config wlroots mesa pango
  ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  mesonFlags = [ "--sysconfdir" "/etc" ];

  passthru = {
    providedSessions = [ "wayfire" ];
  };

  meta = with lib; {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
