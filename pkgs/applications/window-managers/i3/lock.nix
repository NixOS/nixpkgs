{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutilimage,
  pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  name = "i3lock-${version}";
  version = "2.10";

  src = fetchurl {
    url = "https://i3wm.org/i3lock/${name}.tar.bz2";
    sha256 = "1vn8828ih7mpdl58znfnzpdwdgwksq16rghm5qlppbbz66zk5sr9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile ];

  makeFlags = "all";
  installFlags = "PREFIX=\${out} SYSCONFDIR=\${out}/etc";
  postInstall = ''
    mkdir -p $out/share/man/man1
    cp *.1 $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "A simple screen locker like slock";
    longDescription = ''
      Simple screen locker. After locking, a colored background (default: white) or
      a configurable image is shown, and a ring-shaped unlock-indicator gives feedback
      for every keystroke. After entering your password, the screen is unlocked again.
    '';
    homepage = https://i3wm.org/i3lock/;
    maintainers = with maintainers; [ garbas malyn domenkozar ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };

}
