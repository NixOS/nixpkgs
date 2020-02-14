{ stdenv, fetchFromGitHub, libX11, libXinerama, libXrandr, libXft, yacc, pkgconfig }:

stdenv.mkDerivation rec {

  pname = "cwm";
  version = "6.6";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rvb4y37vw3bpkqa6fbizgc74x3nrlkk6yf5hlm0hf8qz0c17vbl";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXinerama libXrandr libXft yacc ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = with stdenv.lib; {
    description = "A lightweight and efficient window manager for X11";
    homepage    = "https://github.com/leahneukirchen/cwm";
    maintainers = with maintainers; [ "0x4A6F" mkf ];
    license     = licenses.isc;
    platforms   = platforms.linux;
  };
}
