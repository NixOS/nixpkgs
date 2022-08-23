{ stdenv, cmake, lib, fetchFromGitHub, qt5, fftw, libtorch-bin, portaudio, eigen
, xorg, pkg-config, autoPatchelfHook, soxr
}:

stdenv.mkDerivation rec {
  pname = "in-formant";
  version = "2021-06-30";

  # no Qt6 yet, so we're stuck in the last Qt5-supporting commit: https://github.com/NixOS/nixpkgs/issues/108008
  src = fetchFromGitHub {
    owner = "in-formant";
    repo = "in-formant";
    rev = "e28e628cf5ff0949a7b046d220cc884f6035f31a";
    sha256 = "sha256-YvtV0wGUNmI/+GGxrIfTk/l8tqUsWgc/LAI17X+AWGI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config qt5.wrapQtAppsHook autoPatchelfHook ];

  buildInputs = [
    qt5.qtbase
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    qt5.qtcharts
    fftw
    libtorch-bin
    portaudio
    eigen
    xorg.libxcb
    soxr
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp in-formant $out/bin
  '';

  # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=ON" ];

  meta = with lib; {
    description = "A real-time pitch and formant tracking software";
    homepage = "https://github.com/in-formant/in-formant";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ckie ];
  };
}
