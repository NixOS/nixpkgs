{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutilimage,
  pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  name = "i3lock-2.8";

  src = fetchurl {
    url = "http://i3wm.org/i3lock/${name}.tar.bz2";
    sha256 = "028fc0f74df10826514d5a4ed38f6895935d1f5d47ca9fcffc64b076aaf6e2f4";
  };

  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile ];

  makeFlags = "all";
  installFlags = "PREFIX=\${out} SYSCONFDIR=\${out}/etc";
  postInstall = ''
    mkdir -p $out/share/man/man1
    cp *.1 $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "A simple screen locker like slock";
    homepage = http://i3wm.org/i3lock/;
    maintainers = with maintainers; [ garbas malyn domenkozar ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };

}
