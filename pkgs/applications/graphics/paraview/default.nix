{ fetchurl, stdenv, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "paraview-3.8.0";
  src = fetchurl {
    url = "http://www.paraview.org/files/v3.8/ParaView-3.8.0.tar.gz";
    sha256 = "0y20daf59hn9dmbp1cmx0085z34qccwps04hv2lh9s15namca9py";
  };

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/paraview-3.8"
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

