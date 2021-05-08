{ stdenv, lib, fetchurl, meson, ninja, pkg-config, git
, cairo, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, wayland
, wayland-protocols, wf-config, wlroots, mesa
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire/releases/download/v${version}/wayfire-${version}.tar.xz";
    sha256 = "0wgvwbmdhn7gkdr2jl9jndgvl6w4x7ys8gmpj55gqh9b57wqhyaq";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland ];
  buildInputs = [
    cairo libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config wlroots mesa
  ];

  mesonFlags = [ "--sysconfdir" "/etc" ];

  meta = with lib; {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
