{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutilimage,
  pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  name = "i3lock-2.6";

  src = fetchurl {
    url = "http://i3wm.org/i3lock/${name}.tar.bz2";
    sha256 = "0aj0an8fwv66jhda499r3xa00546cc9ja1dk8xpc6sy6xygqjbf0";
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
    description = "i3lock is a simple screen locker like slock";
    homepage = http://i3wm.org/i3lock/;
    maintainers = with maintainers; [ garbas malyn ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };

}
