{ lib, stdenv, fetchurl, wrapGAppsHook4
, cargo, desktop-file-utils, meson, ninja, pkg-config, rustc
, glib, gtk4, libadwaita, libxml2
}:

stdenv.mkDerivation rec {
  pname = "symbolic-preview";
  version = "0.0.3";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/symbolic-preview/uploads/df71a2eee9ea0c90b3d146e7286fec42/symbolic-preview-${version}.tar.xz";
    sha256 = "08g2sbdb1x5z26mi68nmciq6xwv0chvxw6anj1qdfh7npsg0dm4c";
  };

  nativeBuildInputs = [
    cargo desktop-file-utils meson ninja pkg-config rustc wrapGAppsHook4
  ];
  buildInputs = [ glib gtk4 libadwaita libxml2 ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/design/symbolic-preview";
    description = "Symbolics made easy";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
