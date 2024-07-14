{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
    (fetchpatch2 {
      url = "https://github.com/dominikschnitzer/musly/compare/7a0c6a9a2782e6fca84fb86fce5232a8c8a104ed...86ed2b851538fd006848cf9b5bc143acf81a8839.patch";
      hash = "sha256-MJxC66+9DrAjgyECGH7IeaNFExFhCwJmsEnbFvjC3ag=";
    })
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
