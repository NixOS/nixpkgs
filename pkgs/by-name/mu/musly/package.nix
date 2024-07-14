{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  eigen,
  ffmpeg_4,
}:
stdenv.mkDerivation {
  pname = "musly";
  version = "0.1-unstable-2019-09-05";

  src = fetchFromGitHub {
    owner = "dominikschnitzer";
    repo = "musly";
    rev = "7a0c6a9a2782e6fca84fb86fce5232a8c8a104ed";
    hash = "sha256-DOvGGx3pCcvPPsT97sQlINjT1sJy8ZWvxLsFGGZbgzE=";
  };
  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    eigen
    ffmpeg_4
  ];
  fixupPhase = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libmusly.dylib $out/lib/libmusly.dylib $out/bin/musly
    install_name_tool -change libmusly_resample.dylib $out/lib/libmusly_resample.dylib $out/bin/musly
    install_name_tool -change libmusly_resample.dylib $out/lib/libmusly_resample.dylib $out/lib/libmusly.dylib
  '';

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
