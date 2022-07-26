{ lib, stdenv, fetchFromGitHub, cmake, qt4, fftw }:

stdenv.mkDerivation rec {
  pname = "smartdeblur";
  version = "unstable-2013-01-09";

  src = fetchFromGitHub {
    owner = "Y-Vladimir";
    repo = "SmartDeblur";
    rev = "9895036d26cbb823a9ade28cdcb26fd0ac37258e";
    sha256 = "sha256-+EbqEpOG1fj2OKmlz8NRF/CGfT2OYGwY5/lwJHCHaMw=";
  };

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 fftw ];

  cmakeFlags = [ "-DUSE_SYSTEM_FFTW=ON" ];

  meta = with lib; {
    homepage = "https://github.com/Y-Vladimir/SmartDeblur";
    description = "Tool for restoring blurry and defocused images";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
