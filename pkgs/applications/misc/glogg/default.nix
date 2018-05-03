{ stdenv, fetchurl, qt5, boost }:

stdenv.mkDerivation rec {

  name = "glogg-1.1.4";
  
  src = fetchurl {
    url = "http://glogg.bonnefon.org/files/${name}.tar.gz";
    sha256 = "0c1ddc72ebfc255bbb246446fb7be5b0fd1bb1594c70045c3e537cb6d274965b";
  };

  buildInputs = [ qt5.qmake boost ];

  qmakeFlags = [ "glogg.pro" ];

  installCommand = ''
    make install INSTALL_ROOT=$out
  '';

  meta = {
    description = "The fast, smart log explorer";
    longDescription = ''
      A multi-platform GUI application to browse and search through long or complex log files. It is designed with programmers and system administrators in mind. glogg can be seen as a graphical, interactive combination of grep and less.
    '';
    homepage = http://glogg.bonnefon.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.hlolli ];
    platforms = stdenv.lib.platforms.all;
  };
}
