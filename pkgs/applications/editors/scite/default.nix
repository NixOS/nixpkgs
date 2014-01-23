{ stdenv, fetchurl, pkgconfig, gtk }:

let
  version = "3.3.7";

  version_short = stdenv.lib.replaceChars [ "." ] [ "" ] "${version}";
in stdenv.mkDerivation {
  name = "scite-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/scintilla/SciTE/${version}/scite${version_short}.tgz";
    sha256 = "0x7i6yxq50frsjkrp3lc5zy0d1ssq2n91igjn0dmqajpg7kls2dd";
  };

  buildInputs = [ pkgconfig gtk ];
  sourceRoot = "scintilla/gtk";

  buildPhase = ''
    make
    cd ../../scite/gtk
    make prefix=$out/
  '';

  installPhase = ''
    make install prefix=$out/
  '';

  meta = {
    homepage = "http://www.scintilla.org/SciTE.html";
    description = "SCIntilla based Text Editor";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = stdenv.lib.maintainers.rszibele;
  };
}
