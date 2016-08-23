{ stdenv, fetchurl, pkgconfig, libX11, gdk_pixbuf, cairo, libXft, gtk2, fribidi }:

stdenv.mkDerivation rec {
  name = "mlterm-${version}";
  version = "3.3.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/mlterm/01release/${name}/${name}.tar.gz";
    sha256 = "088pgxynzxxii7wdmjp2fdkxydirx4k05588zkhlzalkb5l8ji1i";
  };

  buildInputs = [ pkgconfig libX11 gdk_pixbuf cairo libXft gtk2 fribidi ];

  preConfigure = ''
    sed -ie 's#-L/usr/local/lib -R/usr/local/lib##g' \
      xwindow/libtype/Makefile.in \
      main/Makefile.in \
      java/Makefile.in \
      tool/mlimgloader/Makefile.in \
      tool/registobmp/Makefile.in \
      tool/mlconfig/Makefile.in
    sed -ie 's;cd ..srcdir. && rm -f ...lang..gmo.*;;g' tool/mlconfig/po/Makefile.in.in
  '';

  configureFlags = [
    "--with-imagelib=gdk-pixbuf"
    "--with-type-engines=cairo,xft,xcore"
    "--with-x"
    "--enable-ind"
 ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/mlterm/;
    license = licenses.bsd2;
    maintainers = [ maintainers.vrthra ];
    platforms = with platforms; linux;
  };
}
