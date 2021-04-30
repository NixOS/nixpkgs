{ stdenv, lib, fetchurl, meson, ninja, pkg-config, git
, cairo, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, wayland
, wayland-protocols, wf-config, wlroots, mesa
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire/releases/download/v${version}/wayfire-${version}.tar.xz";
    sha256 = "19k9nk5whql03ik66i06r4xgxk5v7mpdphjpv13hdw8ba48w73hd";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland ];
  buildInputs = [
    cairo libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config wlroots mesa
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
