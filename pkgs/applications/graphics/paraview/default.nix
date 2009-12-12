{ fetchurl, stdenv, cmake, qt4 }:

stdenv.mkDerivation {
  name = "paraview-3.6.1";
  src = fetchurl {
    url = http://www.paraview.org/files/v3.6/paraview-3.6.1.tar.gz;
    sha256 = "1dh0dqbdvjagy122nbwr1gg03ck2if2aqqbvzcpkx38sz12cjh7h";
  };

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/paraview-3.6"
  '';

  buildInputs = [ cmake qt4 ];

  meta = {
    homepage = "http://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

