{ lib, stdenv, fetchurl, pkg-config, gtk2 }:

stdenv.mkDerivation {
  pname = "scite";
  version = "5.0.2";

  src = fetchurl {
    url = "https://www.scintilla.org/scite502.tgz";
    sha256 = "00n2gr915f7kvp2250dzn6n0p6lhr6qdlm1m7y2xi6qrrky0bpan";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];
  sourceRoot = "scintilla/gtk";

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
  };
}
