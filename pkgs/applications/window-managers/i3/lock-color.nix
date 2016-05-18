{ stdenv, fetchFromGitHub, which, pkgconfig, libxcb, xcbutilkeysyms
, xcbutilimage, pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  rev = "63a4c23ec6f0b3f62144122a4277d51caf023e4f";
  name = "i3lock-color-2.7_rev${builtins.substring 0 7 rev}";
  src = fetchFromGitHub {
    owner = "Arcaena";
    repo = "i3lock-color";
    inherit rev;
    sha256 = "1wfp0p85h45l50l6zfk5cr9ynka60vhjlgnyk8mqd5fp0w4ibxip";
  };
  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile ];
  makeFlags = "all";
  preInstall = ''
    mkdir -p $out/share/man/man1
  '';
  installFlags = "PREFIX=\${out} SYSCONFDIR=\${out}/etc MANDIR=\${out}/share/man";
  meta = with stdenv.lib; {
    description = "A simple screen locker like slock";
    homepage = http://i3wm.org/i3lock/;
    maintainers = with maintainers; [ garbas malyn ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
