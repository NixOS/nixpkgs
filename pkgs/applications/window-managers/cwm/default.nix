{ stdenv, fetchFromGitHub, libX11, libXinerama, libXrandr, libXft, yacc, pkgconfig }:

stdenv.mkDerivation rec {

  pname = "cwm";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m08gd6nscwfx6040zbg2zl89m4g73im68iflzcihd6pdc8rzzs4";
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
