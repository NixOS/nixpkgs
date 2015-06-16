{ stdenv, fetchFromGitHub, fftw, libsndfile, qt5 }:

let version = "1.0.1"; in
stdenv.mkDerivation {
  name = "dfasma-${version}";

  src = fetchFromGitHub {
    sha256 = "16m6jnr49j525xxqiwmwni07rcdg92p0dcznd5bmzz34xsm0cbiz";
    rev = "v${version}";
    repo = "dfasma";
    owner = "gillesdegottex";
  };

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
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ fftw libsndfile qt5.base qt5.multimedia ];

  configurePhase = ''
    qmake DESTDIR=$out/bin dfasma.pro
  '';

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm644 distrib/dfasma.desktop $out/share/applications/dfasma.desktop
    install -Dm644 icons/dfasma.png $out/share/pixmaps/dfasma.png
  '';
}
