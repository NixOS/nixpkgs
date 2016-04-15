{ stdenv, fetchFromGitHub, fftw, libsndfile, qtbase, qtmultimedia, makeQtWrapper }:

let

  reaperFork = {
    src = fetchFromGitHub {
      sha256 = "07m2wf2gqyya95b65gawrnr4pvc9jyzmg6h8sinzgxlpskz93wwc";
      rev = "39053e8896eedd7b3e8a9e9a9ffd80f1fc6ceb16";
      repo = "reaper";
      owner = "gillesdegottex";
    };
    meta = with stdenv.lib; {
     license = licenses.asl20;
    };
  };

  libqaudioextra = {
    src = fetchFromGitHub {
      sha256 = "17pvlij8cc4lwzf6f1cnygj3m3ci6xfa3lv5bgcr5i1gzyjxqpq1";
      rev = "b7d187cd9a1fd76ea94151e2e02453508d0151d3";
      repo = "libqaudioextra";
      owner = "gillesdegottex";
    };
    meta = with stdenv.lib; {
     license = licenses.gpl3Plus;
    };
  };

in stdenv.mkDerivation rec {
  name = "dfasma-${version}";
  version = "1.2.5";

  src = fetchFromGitHub {
    sha256 = "0mgy2bkmyp7lvaqsr7hkndwdgjf26mlpsj6smrmn1vp0cqyrw72d";
    rev = "v${version}";
    repo = "dfasma";
    owner = "gillesdegottex";
  };

  buildInputs = [ fftw libsndfile qtbase qtmultimedia ];

  nativeBuildInputs = [ makeQtWrapper ];

  postPatch = ''
    substituteInPlace dfasma.pro --replace '$$DFASMAVERSIONGITPRO' '${version}'
    cp -Rv "${reaperFork.src}"/* external/REAPER
    cp -Rv "${libqaudioextra.src}"/* external/libqaudioextra
  '';

  configurePhase = ''
    runHook preConfigure
    qmake PREFIX=$out PREFIXSHORTCUT=$out dfasma.pro
    runHook postConfigure
  '';

  enableParallelBuilding = true;

  postInstall = ''
    wrapQtProgram "$out/bin/dfasma"
  '';

  meta = with stdenv.lib; {
    description = "Analyse and compare audio files in time and frequency";
    longDescription = ''
      DFasma is free open-source software to compare audio files by time and
      frequency. The comparison is first visual, using wavforms and spectra. It
      is also possible to listen to time-frequency segments in order to allow
      perceptual comparison. It is basically dedicated to analysis. Even though
      there are basic functionalities to align the signals in time and
      amplitude, this software does not aim to be an audio editor.
    '';
    homepage = http://gillesdegottex.github.io/dfasma/;
    license = [ licenses.gpl3Plus reaperFork.meta.license ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
