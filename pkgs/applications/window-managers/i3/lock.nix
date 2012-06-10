{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutilimage,
  pam, libX11, libev, cairo }:

stdenv.mkDerivation rec {
  name = "i3lock-2.4.1";

  src = fetchurl {
    url = "http://i3wm.org/i3lock/${name}.tar.bz2";
    sha256 = "4d29e66841138de562e71903d31ecaaefd8ecffe5e68da0d6c8d560ed543047c";
  };

  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo ];

  makeFlags = "all";
  installFlags = "PREFIX=\${out} SYSCONFDIR=\${out}/etc";

  meta = {
    description = "i3 is a tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
  };

}
