{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  cmake,
  ninja,
  pkg-config,
  python3,
  git,
  SDL2,
  SDL2_ttf,
  freetype,
  harfbuzz,
  ffmpeg,
  cacert,
}:

let
  version = "1.0.0";
  withSubprojects = stdenv.mkDerivation {
    name = "sources-with-subprojects";

    src = fetchFromGitHub {
      owner = "vivictorg";
      repo = "vivictpp";
      rev = "v${version}";
      hash = "sha256-dCtMjemEjXe63ELAfQhzJl3GecqWLcjL2y5Htn6hYgU=";
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
    outputHash = "sha256-a7NBQJt5T+KwP8Djc8TQiVLNZF8UcXlXrv2G/dZ54aM=";
  };
in
stdenv.mkDerivation rec {
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
    mainProgram = "vivictpp";
  };
}
