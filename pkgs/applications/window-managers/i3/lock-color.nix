{ stdenv, fetchFromGitHub, which, pkgconfig, libxcb, xcbutilkeysyms
, xcbutilimage, pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  rev = "c8e1aece7301c3c6481bf2f695734f8d273f252e";
  version = "2.7-2016-09-17";
  name = "i3lock-color-${version}";
  src = fetchFromGitHub {
    owner = "chrjguill";
    repo = "i3lock-color";
    inherit rev;
    sha256 = "07fpvwgdfxsnxnf63idrz3n1kbyayr53lsfns2q775q93cz1mfia";
  };
  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutilimage pam libX11
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
