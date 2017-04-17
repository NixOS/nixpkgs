{ stdenv, fetchFromGitHub, which, pkgconfig, libxcb, xcbutilkeysyms
, xcbutilimage, pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  version = "2.7-2017-04-01";
  name = "i3lock-color-${version}";

  src = fetchFromGitHub {
    owner = "chrjguill";
    repo = "i3lock-color";
    rev = "61f6428aedbe4829d3e0f51d137283c8aec1e206";
    sha256 = "0h4nzx46kcsp6b1i2lm9y4d1w1icrpvjl8g1h3wbpa5x4crh4703";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile ];

  makeFlags = "all";
  preInstall = ''
    mkdir -p $out/share/man/man1
  '';
  installFlags = "PREFIX=\${out} SYSCONFDIR=\${out}/etc MANDIR=\${out}/share/man";
  postInstall = ''
    mv $out/bin/i3lock $out/bin/i3lock-color
  '';
  meta = with stdenv.lib; {
    description = "A simple screen locker like slock";
    homepage = http://i3wm.org/i3lock/;
    maintainers = with maintainers; [ garbas malyn ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
