{ stdenv, fetchurl, bzip2, qt4, libX11, xextproto, libXtst }:

stdenv.mkDerivation rec {
  name = "keepassx-0.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/keepassx/${name}.tar.gz";
    sha256 = "cd901a0611ce57e62cf6df7eeeb1b690b5232302bdad8626994eb54adcfa1e85";
  };

  configurePhase = ''
    qmake PREFIX=$out 
  '';

  buildInputs = [ bzip2 qt4 libX11 xextproto libXtst ];

  meta = {
    description = "Qt password manager compatible with its Win32 and Pocket PC versions";
    homepage = http://http://www.keepassx.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; linux;
  };
}
