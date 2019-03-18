{ stdenv, fetchurl, desktop-file-utils, gettext,
  meson, ninja, pkgconfig, rustc, cargo, wrapGAppsHook,
  cairo, glib, gtk3-x11, pango
}:

stdenv.mkDerivation rec {
  name = "gxi-${version}";
  version = "0.5.5";

  src = fetchurl {
    url = "https://github.com/Cogitri/gxi/releases/download/v${version}/gxi-${version}.tar.xz";
    sha256 = "00h7a4qa60b0aljw1vr9pqk1i6g7yjhg9ysgjrsw70w6cfsl39hv";
  };

  nativeBuildInputs = [
    meson ninja rustc cargo pkgconfig
    gettext desktop-file-utils wrapGAppsHook
  ];
  buildInputs = [ stdenv cairo glib gtk3-x11 pango ];

  enableParallelBuilding = true;

  preConfigure = ''
    export DESTDIR=/
  '';

  meta = with stdenv.lib; {
    description = "GTK frontend for the xi text editor, written in Rust";
    homepage = https://gxi.cogitri.dev;
    license = licenses.mit;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.linux;
  };
}
