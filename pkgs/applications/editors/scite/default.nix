{ lib, stdenv, fetchurl, pkg-config, gtk2 }:

stdenv.mkDerivation {
  pname = "scite";
  version = "5.2.2";

  src = fetchurl {
    url = "https://www.scintilla.org/scite522.tgz";
    sha256 = "1q46clclx8r0b8zbq2zi89sygszgqf9ra5l83r2fs0ghvjgh2cxd";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];
  sourceRoot = "scintilla/gtk";

  CXXFLAGS = [
    # GCC 13: error: 'intptr_t' does not name a type
    "-include cstdint"
    "-include system_error"
  ];

  buildPhase = ''
    make
    cd ../../lexilla/src
    make
    cd ../../scite/gtk
    make prefix=$out/
  '';

  installPhase = ''
    make install prefix=$out/
  '';

  meta = with lib; {
    homepage = "https://www.scintilla.org/SciTE.html";
    description = "SCIntilla based Text Editor";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.rszibele ];
    mainProgram = "SciTE";
  };
}
