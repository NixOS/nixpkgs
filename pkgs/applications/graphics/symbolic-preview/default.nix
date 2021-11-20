{ lib, stdenv, fetchurl, wrapGAppsHook
, cargo, desktop-file-utils, meson, ninja, pkg-config, python3, rustc
, gdk-pixbuf, glib, gtk3, libhandy, libxml2
}:

stdenv.mkDerivation rec {
  pname = "symbolic-preview";
  version = "0.0.2";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/symbolic-preview/uploads/91fd27bb70553c8d6c3ad2a35446ff6e/symbolic-preview-${version}.tar.xz";
    sha256 = "1v8l10ppwbjkrq7nvb0wqc3pid6pd8dqpki3jhmjjkmbd7rpdpkq";
  };

  nativeBuildInputs = [
    cargo desktop-file-utils meson ninja pkg-config python3 rustc wrapGAppsHook
  ];
  buildInputs = [ gdk-pixbuf glib gtk3 libhandy libxml2 ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/design/symbolic-preview";
    description = "Symbolics made easy";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
