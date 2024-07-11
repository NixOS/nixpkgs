{ mkDerivation
, lib
, fetchFromGitHub
, pkg-config
, SDL2
, qtdeclarative
, libpulseaudio
, glm
, cmake
, which
}:

mkDerivation rec {
  pname = "projectm";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectM";
    rev = "v${version}";
    sha256 = "sha256-b8yWy7PHEtBgGEub8+wd0xlqS7jHdbCd3iHMJ/xcXmA=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    cmake
  ];

  buildInputs = [
    SDL2
    qtdeclarative
    libpulseaudio
    glm
  ];

  configureFlags = [
    "--enable-qt"
    "--enable-sdl"
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = {
    homepage = "https://github.com/projectM-visualizer/projectm";
    description = "Cross-platform Milkdrop-compatible music visualizer";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pinpox ];
    longDescription = ''
      The open-source project that reimplements the esteemed Winamp Milkdrop by Geiss in a more modern, cross-platform reusable library.
      Read an audio input and produces mesmerizing visuals, detecting tempo, and rendering advanced equations into a limitless array of user-contributed visualizations.
    '';
  };
}
