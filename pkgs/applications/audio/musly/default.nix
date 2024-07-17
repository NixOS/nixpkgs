{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  ffmpeg_4,
}:
stdenv.mkDerivation {
  pname = "musly";
  version = "unstable-2017-04-26";
  src = fetchFromGitHub {
    owner = "dominikschnitzer";
    repo = "musly";
    rev = "f911eacbbe0b39ebe87cb37d0caef09632fa40d6";
    sha256 = "1q42wvdwy2pac7bhfraqqj2czw7w2m33ms3ifjl8phm7d87i8825";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    ffmpeg_4
  ];
  fixupPhase = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libmusly.dylib $out/lib/libmusly.dylib $out/bin/musly
    install_name_tool -change libmusly_resample.dylib $out/lib/libmusly_resample.dylib $out/bin/musly
    install_name_tool -change libmusly_resample.dylib $out/lib/libmusly_resample.dylib $out/lib/libmusly.dylib
  '';

  meta = with lib; {
    homepage = "https://www.musly.org";
    description = "A fast and high-quality audio music similarity library written in C/C++";
    longDescription = ''
      Musly analyzes the the audio signal of music pieces to estimate their similarity.
      No meta-data about the music piece is included in the similarity estimation.
      To use Musly in your application, have a look at the library documentation
      or try the command line application included in the package and start generating
      some automatic music playlists right away.
    '';
    license = licenses.mpl20;
    maintainers = with maintainers; [ ggpeti ];
    platforms = with platforms; darwin ++ linux;
    mainProgram = "musly";
  };
}
