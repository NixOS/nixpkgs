{ stdenv, lib, fetchurl, meson, ninja, pkg-config, wayland, wrapGAppsHook
, gtk3, libevdev, libxml2, wayfire, wayland-protocols, wf-config, wf-shell
}:

stdenv.mkDerivation rec {
  pname = "wcm";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wcm/releases/download/v${version}/wcm-${version}.tar.xz";
    sha256 = "19za1fnlf5hz4n4mxxwqcr5yxp6mga9ah539ifnjnqrgvj19cjlj";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland wrapGAppsHook ];
  buildInputs = [
    gtk3 libevdev libxml2 wayfire wayland
    wayland-protocols wf-config wf-shell
  ];

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
