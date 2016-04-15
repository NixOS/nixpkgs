{ stdenv, fetchurl, qtbase, qtsvg, boost }:

stdenv.mkDerivation rec {

  version = "0.9.0b";
  name = "fritzing-${version}";

  src = fetchurl {
    url = "http://fritzing.org/download/${version}/source-tarball/fritzing-${version}.source.tar_1.bz2";
    sha256 = "181qnknq1j5x075icpw2qk0sc4wcj9f2hym533vs936is0wxp2gk";
  };

  unpackPhase = ''
    tar xjf ${src}
  '';

  buildInputs = [ qtbase qtsvg boost ];

  configurePhase = ''
    runHook preConfigure
    cd fritzing-${version}.source
    echo $PATH
    qmake PREFIX=$out phoenix.pro
    runHook postConfigure
  '';

  meta = {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = http://fritzing.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.robberer ];
  }; 
}
