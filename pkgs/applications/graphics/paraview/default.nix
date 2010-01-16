{ fetchurl, stdenv, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "paraview-3.6.2";
  src = fetchurl {
    url = "http://www.paraview.org/files/v3.6/${name}.tar.gz";
    sha256 = "017axalkiaqd13jfbb4awcxvpndnzaq35ys7svm5rnizdwd5hbq6";
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

