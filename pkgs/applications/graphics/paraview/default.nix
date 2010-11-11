{ fetchurl, stdenv, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "paraview-3.8.1";
  src = fetchurl {
    url = "http://www.paraview.org/files/v3.8/ParaView-3.8.1.tar.gz";
    sha256 = "0g169vc956gifkd90lcini63dkr5x3id3hkwcwxzriqamxr72r1p";
  };

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/paraview-3.8"
  '';

  # I don't enable it due to memory bounds
  enableParallelBuilding = false;

  buildInputs = [ cmake qt4 ];

  meta = {
    homepage = "http://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

