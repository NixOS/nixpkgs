{ stdenv, fetchFromGitHub, cmake, eigen, libav_all }:
stdenv.mkDerivation rec {
  name = "musly-${version}";
  version = "0.2";
  src = fetchFromGitHub {
    owner = "dominikschnitzer";
    repo = "musly";
    rev = "f911eacbbe0b39ebe87cb37d0caef09632fa40d6";
    sha256 = "1q42wvdwy2pac7bhfraqqj2czw7w2m33ms3ifjl8phm7d87i8825";
  };
  buildInputs = [ cmake eigen (libav_all.override { vaapiSupport = stdenv.isLinux; }).libav_11 ];
  preBuild = ''
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$out $src
  '';
  fixupPhase = if stdenv.isDarwin then ''
    install_name_tool -change libmusly.dylib $out/lib/libmusly.dylib $out/bin/musly
    install_name_tool -change libmusly_resample.dylib $out/lib/libmusly_resample.dylib $out/bin/musly
    install_name_tool -change libmusly_resample.dylib $out/lib/libmusly_resample.dylib $out/lib/libmusly.dylib
  '' else "";

  meta = with stdenv.lib; {
    homepage = http://www.musly.org;
    description = "A fast and high-quality audio music similarity library written in C/C++";
    longDescription = ''
      Musly analyzes the the audio signal of music pieces to estimate their similarity.
      No meta-data about the music piece is included in the similarity estimation.
      To use Musly in your application, have a look at the library documentation
      or try the command line application included in the package and start generating
      some automatic music playlists right away.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ggpeti ];
  };
}