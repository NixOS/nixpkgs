{stdenv, fetchurl, xlibs, cmake, subversion, libGLU_combined, qt5, boost,
 python27, python27Packages}:

stdenv.mkDerivation rec {
  version = "201707";
  build_nr = "1";
  name = "mcrl2-${version}";

  src = fetchurl {
    url = "http://www.mcrl2.org/download/release/mcrl2-${version}.${build_nr}.tar.gz";
    sha256 = "1c8h94ja7271ph61zrcgnjgblxppld6v22f7f900prjgzbcfy14m";
  };

  buildInputs = [ cmake libGLU_combined qt5.qtbase boost ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A toolset for model-checking concurrent systems and protocols";
    longDescription = ''
      A formal specification language with an associated toolset,
      that can be used for modelling, validation and verification of
      concurrent systems and protocols
    '';
    homepage = http://www.mcrl2.org/;
    license = licenses.boost;
    maintainers = with maintainers; [ moretea ];
    platforms = platforms.unix;
  };
}
