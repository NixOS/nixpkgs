{ lib, stdenv, fetchFromGitHub
, meson, cmake, ninja, pkg-config
, python3, git
, SDL2, SDL2_ttf
, freetype, harfbuzz
, ffmpeg
, cacert }:

let
  version = "0.3.1";
  withSubprojects = stdenv.mkDerivation {
    name = "sources-with-subprojects";

    src = fetchFromGitHub {
      owner = "vivictorg";
      repo = "vivictpp";
      rev = "v${version}";
      hash = "sha256-6YfYeUrM7cq8hnOPMq0Uq/HToFBDri0N/r0SU0LeT/Y=";
    };

    nativeBuildInputs = [
      meson
      cacert
      git
    ];

    buildCommand = ''
      cp -r --no-preserve=mode $src $out
      cd $out

      meson subprojects download
      find subprojects -type d -name .git -prune -execdir rm -r {} +
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-lIm2Bwy61St9d1e6QSm5ZpSIDR9ucaQKBPHATTDEgW4=";
  };
in stdenv.mkDerivation rec {
  pname = "vivictpp";
  inherit version;

  src = withSubprojects;

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config

    python3
    git
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    freetype
    harfbuzz
    ffmpeg
  ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with lib; {
    description = "An easy to use tool for subjective comparison of the visual quality of different encodings of the same video source";
    homepage = "https://github.com/vivictorg/vivictpp";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tilpner ];
  };
}
