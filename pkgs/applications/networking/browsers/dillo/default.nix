{ lib, stdenv, fetchurl
, fltk
, openssl
, libjpeg, libpng
, perl
, libXcursor, libXi, libXinerama }:

stdenv.mkDerivation rec {
  version = "3.0.5";
  pname = "dillo";

  src = fetchurl {
    url = "https://www.dillo.org/download/${pname}-${version}.tar.bz2";
    sha256 = "12ql8n1lypv3k5zqgwjxlw1md90ixz3ag6j1gghfnhjq3inf26yv";
  };

  buildInputs = with lib;
  [ perl fltk openssl libjpeg libpng libXcursor libXi libXinerama ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: main.o:/build/dillo-3.0.5/dpid/dpid.h:64: multiple definition of `sock_set';
  #     dpid.o:/build/dillo-3.0.5/dpid/dpid.h:64: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  configureFlags = [ "--enable-ssl" ];

  meta = with lib; {
    homepage = "https://www.dillo.org/";
    description = "A fast graphical web browser with a small footprint";
    longDescription = ''
      Dillo is a small, fast web browser, tailored for older machines.
    '';
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
