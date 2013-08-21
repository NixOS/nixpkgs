{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutilimage,
  pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  name = "i3lock-2.5";

  src = fetchurl {
    url = "http://i3wm.org/i3lock/${name}.tar.bz2";
    sha256 = "0xqdklvfcn2accwdbzsly7add0f3rh9sxjnahawas4zwwk4p49xc";
  };

  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile ];

  makeFlags = "all";
  installFlags = "PREFIX=\${out} SYSCONFDIR=\${out}/etc";

  meta = {
    description = "i3 is a tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };

}
