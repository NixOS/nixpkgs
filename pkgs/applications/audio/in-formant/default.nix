{ stdenv
, cmake
, lib
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qtcharts
, fftw
, libtorch-bin
, portaudio
, eigen
, xorg
, pkg-config
, autoPatchelfHook
, soxr
, freetype
, libsamplerate
, armadillo
, tomlplusplus
}:

stdenv.mkDerivation rec {
  pname = "in-formant";
  version = "unstable-2022-09-15";

  src = fetchFromGitHub {
    owner = "in-formant";
    repo = "in-formant";
    rev = "e0606feecff70f0fd4226ff8f116e46817dd7462";
    hash = "sha256-/4eKny9M2e8Lb9LOiKBj9QLE00CAaD+2ZAwn48lnvKQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Ignore the freetype sources bundled as a submodule:
    # /nix/store/…-harfbuzz-7.0.0/lib/libharfbuzz.so.0: undefined reference to `FT_Get_Transform'
    ./0001-Avoid-using-vendored-dependencies-we-have-in-nixpkgs.patch
  ];

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook autoPatchelfHook ];

  buildInputs = [
    qtbase
    qtcharts
    fftw
    libtorch-bin
    portaudio
    eigen
    xorg.libxcb
    soxr
    libsamplerate
    armadillo
    tomlplusplus
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp in-formant $out/bin
  '';

  meta = with lib; {
    description = "A real-time pitch and formant tracking software";
    homepage = "https://github.com/in-formant/in-formant";
    license = licenses.asl20;
    # currently broken on i686-linux and aarch64-linux due to other nixpkgs dependencies
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ckie ];
  };
}
