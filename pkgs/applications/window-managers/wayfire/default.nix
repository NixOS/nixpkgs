{ stdenv, lib, fetchurl, meson, ninja, pkg-config, git
, cairo, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, wayland
, wayland-protocols, wf-config, wlroots
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire/releases/download/${version}/wayfire-${version}.tar.xz";
    sha256 = "0wc5szslgf8d4r4dlbfgc5v49j2ziaa8fycmknq4p0vl67mh7acq";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland ];
  buildInputs = [
    cairo libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config wlroots
  ];

  mesonFlags = [ "--sysconfdir" "/etc" ];

  meta = with lib; {
    homepage = "https://wayfire.org/";
    description = "3D wayland compositor";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
