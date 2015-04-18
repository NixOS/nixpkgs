{ stdenv, fetchgit, cmake, python, libX11, qt4 }:

stdenv.mkDerivation {
  name = "apitrace-09519af205";

  src = fetchgit {
    url = git://github.com/apitrace/apitrace.git;
    rev = "09519af2056879ce0ea59f7085ac4b282c7d01d0";
    sha256 = "1ka34fhl85k90r7kvp89awlqb6prkbqx0kg1whb3535rnvficxdv";
  };

  buildInputs = [ cmake python libX11 qt4 ];

  buildPhase = ''
    cmake
    make
  '';

  meta = with stdenv.lib; {
    homepage = https://apitrace.github.io;
    description = "A set of tools to trace OpenGL, OpenGL ES, Direct3D, and DirectDraw APIs";
    platforms = platforms.linux;
  };
}
