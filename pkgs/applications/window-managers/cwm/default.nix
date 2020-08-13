{ stdenv, fetchFromGitHub, libX11, libXinerama, libXrandr, libXft, yacc, pkgconfig }:

stdenv.mkDerivation rec {

  pname = "cwm";
  version = "6.7";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f9xmki2hx10k8iisfzc7nm1l31zkf1r06pdgn06ar9w9nizrld9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXinerama libXrandr libXft yacc ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = with stdenv.lib; {
    description = "A lightweight and efficient window manager for X11";
    homepage    = "https://github.com/leahneukirchen/cwm";
    maintainers = with maintainers; [ maintainers."0x4A6F" mkf ];
    license     = licenses.isc;
    platforms   = platforms.linux;
  };
}
