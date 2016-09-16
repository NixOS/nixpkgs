{ stdenv, fetchurl, pkgconfig, autoconf
, libX11, gdk_pixbuf, cairo, libXft, gtk3, vte, fribidi, libssh2
}:

stdenv.mkDerivation rec {
  name = "mlterm-${version}";
  version = "3.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/mlterm/01release/${name}/${name}.tar.gz";
    sha256 = "1b24w8hfck1ylfkdz9z55vlmsb36q9iyfr0i9q9y98dfk0f0rrw8";
  };

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs = [
    libX11 gdk_pixbuf.dev cairo libXft gtk3 vte fribidi libssh2
  ];

  preConfigure = ''
    sed -ie 's#-L/usr/local/lib -R/usr/local/lib##g' \
      xwindow/libtype/Makefile.in \
      main/Makefile.in \
      tool/mlfc/Makefile.in \
      tool/mlimgloader/Makefile.in \
      tool/mlconfig/Makefile.in \
      xwindow/libotl/Makefile.in
    sed -ie 's;cd ..srcdir. && rm -f ...lang..gmo.*;;g' \
      tool/mlconfig/po/Makefile.in.in
  '';

  configureFlags = [
    "--with-x=yes"
    "--with-gtk=3.0"
    "--with-imagelib=gdk-pixbuf"
    "--with-gui=xlib"
    "--with-type-engines=cairo,xft,xcore"
    "--enable-ind"
    "--enable-fribidi"
    "--with-tools=mlclient,mlconfig,mlcc,mlterm-menu,mlimgloader,registobmp,mlfc"
    "--disable-utmp"
 ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/mlterm/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux;
  };
}
