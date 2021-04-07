{ fetchurl, lib, stdenv, cmake, qt4, fftw }:

let
  rev = "9895036d26";
in
stdenv.mkDerivation rec {
  name = "smartdeblur-git-${rev}";

  src = fetchurl {
    url = "https://github.com/Y-Vladimir/SmartDeblur/tarball/${rev}";
    name = "${name}.tar.gz";
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
