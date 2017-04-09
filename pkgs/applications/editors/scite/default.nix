{ stdenv, fetchurl, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "scite-${version}";
  version = "3.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/project/scintilla/SciTE/${version}/scite373.tgz";
    sha256 = "05d81h1fqhjlw9apvrni3x2q4a562cd5ra1071qpna8h4ml0an9m";
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
