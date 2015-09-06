{ stdenv, fetchFromGitHub, fftw, libsndfile, qt5 }:

let

  version = "1.2.0";
  rev = "v${version}";
  sha256 = "05w2sqnzxy4lwc0chjlizpxqwc6ni58yz8xcwvp18fq68wa28qvf";

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

in stdenv.mkDerivation {
  name = "dfasma-${version}";

  src = fetchFromGitHub {
    inherit sha256 rev;
    repo = "dfasma";
    owner = "gillesdegottex";
  };

  buildInputs = [ fftw libsndfile qt5.base qt5.multimedia ];

  postPatch = ''
    substituteInPlace dfasma.pro --replace '$$DFASMAVERSIONGITPRO' '${version}'
    cp -Rv "${reaperFork.src}"/* external/REAPER
  '';

  configurePhase = ''
    qmake PREFIX=$out PREFIXSHORTCUT=$out dfasma.pro
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit version;
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
