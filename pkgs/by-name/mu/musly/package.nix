{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  eigen,
  ffmpeg_7,
  libresample,
  kissfft,
}:

stdenv.mkDerivation {
  pname = "musly";
  version = "0.1-unstable-2019-09-05";

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "dominikschnitzer";
    repo = "musly";
    rev = "7a0c6a9a2782e6fca84fb86fce5232a8c8a104ed";
    hash = "sha256-DOvGGx3pCcvPPsT97sQlINjT1sJy8ZWvxLsFGGZbgzE=";
  };

  patches = [
    # Fix build with FFmpeg 7, C++17, and external libresample and kissfft
    # https://github.com/dominikschnitzer/musly/pull/53
    # Last commit omitted, as it is a large non‐functional removal
    ./0001-Fix-build-with-FFmpeg-7.patch
    ./0002-Fix-build-with-C-17.patch
    ./0003-Modernize-CMake-build-system.patch
    ./0004-Use-pkg-config-to-find-libresample-and-kissfft.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    eigen
    ffmpeg_7
    libresample
    kissfft
  ];

  doCheck = true;

  meta = {
    homepage = "https://www.musly.org";
    description = "Fast and high-quality audio music similarity library written in C/C++";
    longDescription = ''
      Musly analyzes the the audio signal of music pieces to estimate their similarity.
      No meta-data about the music piece is included in the similarity estimation.
      To use Musly in your application, have a look at the library documentation
      or try the command line application included in the package and start generating
      some automatic music playlists right away.
    '';
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ggpeti ];
    platforms = lib.platforms.unix;
    mainProgram = "musly";
  };
}
