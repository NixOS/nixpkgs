{ stdenv, fetchurl, makeWrapper, cmake, qt4, pkgconfig, alsaLib, portaudio, jack2, libsndfile}:

stdenv.mkDerivation rec {
  name = "musescore-1.3";

  src = fetchurl {
    url = "http://ftp.osuosl.org/pub/musescore/releases/MuseScore-1.3/mscore-1.3.tar.bz2";
    sha256 = "a0b60cc892ac0266c58fc6392be72c0a21c3aa7fd0b6e4f1dddad1c8b36be683";
  };

  buildInputs = [ makeWrapper cmake qt4 pkgconfig alsaLib portaudio jack2 libsndfile ];

  configurePhase = ''
    cd mscore;
    mkdir build;
    cd build;
    cmake -DCMAKE_INSTALL_PREFIX=$out -DQT_PLUGINS_DIR=$out/lib/qt4/plugins -DCMAKE_BUILD_TYPE=Release ..'';

  preBuild = ''make lrelease;'';

  postInstall = ''
    wrapProgram $out/bin/mscore --prefix QT_PLUGIN_PATH : $out/lib/qt4/plugins
  '';

  meta = with stdenv.lib; {
    description = "Qt-based score editor";
    homepage = http://musescore.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vandenoever ];
    repositories.git = https://github.com/musescore/MuseScore;
  };
}
