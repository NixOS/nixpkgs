{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutilimage,
  pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  name = "i3lock-${version}";
  version = "2.9.1";

  src = fetchurl {
    url = "https://i3wm.org/i3lock/${name}.tar.bz2";
    sha256 = "1467ha4ssbfjk1jh0ya2i5ljzm554ln18nyrppvsipg8shb1cshh";
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
