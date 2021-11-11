{ fetchurl, lib, stdenv, cmake, qt4, fftw }:

stdenv.mkDerivation rec {
  pname = "smartdeblur";
  version = "unstable-2013-01-09";

  src = fetchurl {
    url = "https://github.com/Y-Vladimir/SmartDeblur/tarball/9895036d26";
    name = "smartdeblur-${version}.tar.gz";
    sha256 = "126x9x1zhqdarjz9in0p1qhmqg3jwz7frizadjvx723g2ppi33s4";
  };

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 fftw ];

  cmakeFlags = [ "-DUSE_SYSTEM_FFTW=ON" ];

  meta = {
    homepage = "https://github.com/Y-Vladimir/SmartDeblur";
    description = "Tool for restoring blurry and defocused images";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
