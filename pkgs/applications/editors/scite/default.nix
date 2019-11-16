{ stdenv, fetchurl, pkgconfig, gtk2 }:

stdenv.mkDerivation {
  pname = "scite";
  version = "4.0.5";

  src = fetchurl {
    url = https://www.scintilla.org/scite405.tgz;
    sha256 = "0h16wk2986nkkhhdv5g4lxlcn02qwyja24x1r6vf02r1hf46b9q2";
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
    homepage = https://www.scintilla.org/SciTE.html;
    description = "SCIntilla based Text Editor";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.rszibele ];
  };
}
