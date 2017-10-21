{ stdenv, fetchFromGitHub, libX11, libXinerama, libXrandr, libXft, yacc, pkgconfig }:

stdenv.mkDerivation rec {
  name = "cwm-5.6";

  src = fetchFromGitHub {
      owner = "chneukirchen";
      repo = "cwm";
      rev = "b7a8c11750d11721a897fdb8442d52f15e7a24a0";
      sha256 = "0a0x8rgqif4kxy7hj70hck7jma6c8jy4428ybl8fz9qxgxh014ml";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXinerama libXrandr libXft yacc ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = with stdenv.lib; {
    description = "A lightweight and efficient window manager for X11";
    homepage = https://github.com/chneukirchen/cwm;
    maintainers = [];
    license     = licenses.isc;
    platforms   = platforms.linux;
  };
}
