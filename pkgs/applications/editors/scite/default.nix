{ stdenv, fetchurl, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "scite-${version}";
  version = "3.7.5";

  src = fetchurl {
    url = http://www.scintilla.org/scite375.tgz;
    sha256 = "11pg9bifyyqpblqsrl1b9f8shb3fa6fgzclvjba6hwh7hh98drji";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 ];
  sourceRoot = "scintilla/gtk";

  buildPhase = ''
    make
    cd ../../scite/gtk
    make prefix=$out/
  '';

  installPhase = ''
    make install prefix=$out/
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.scintilla.org/SciTE.html";
    description = "SCIntilla based Text Editor";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.rszibele ];
  };
}
