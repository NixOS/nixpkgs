{lib, stdenv, fetchurl, cmake, libGLU, libGL, qt5, boost}:

stdenv.mkDerivation rec {
  version = "202307";
  build_nr = "1";
  pname = "mcrl2";

  src = fetchurl {
    url = "https://www.mcrl2.org/download/release/mcrl2-${version}.${build_nr}.tar.gz";
    hash = "sha256-zCHCO8tGyOxqUc0x3t/N3dUh4eG7slemlgK/QZsA4JA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGLU libGL qt5.qtbase boost ];

  dontWrapQtApps = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A toolset for model-checking concurrent systems and protocols";
    longDescription = ''
      A formal specification language with an associated toolset,
      that can be used for modelling, validation and verification of
      concurrent systems and protocols
    '';
    homepage = "https://www.mcrl2.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ moretea ];
    platforms = platforms.unix;
  };
}
