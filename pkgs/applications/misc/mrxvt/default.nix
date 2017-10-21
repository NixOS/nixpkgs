{ stdenv, fetchurl, libX11, libXft, libXi, inputproto, libSM, libICE
, freetype, pkgconfig, which }:

stdenv.mkDerivation {
  name = "mrxvt-0.5.4";

  buildInputs =
    [ libX11 libXft libXi inputproto libSM libICE freetype pkgconfig which ];

  configureFlags = [
    "--with-x"
    "--enable-frills"
    "--enable-xft"
    "--enable-xim"
    # "--with-term=xterm"
    "--with-max-profiles=100"
    "--with-max-term=100"
    "--with-save-lines=10000"
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype.dev}/include/freetype2";
  '';

  src = fetchurl {
    url = mirror://sourceforge/materm/mrxvt-0.5.4.tar.gz;
    sha256 = "1mqhmnlz32lvld9rc6c1hyz7gjw4anwf39yhbsjkikcgj1das0zl";
  };

  meta = { 
    description = "Lightweight multitabbed feature-rich X11 terminal emulator";
    longDescription = "
    	Multitabbed lightweight terminal emulator based on rxvt. 
	Supports transparency, backgroundimages, freetype fonts, ...
    ";
    homepage = http://sourceforge.net/projects/materm;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
