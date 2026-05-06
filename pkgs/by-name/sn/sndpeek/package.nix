{
  lib,
  stdenv,
  fetchurl,
  libsndfile,
  libglut,
  alsa-lib,
  libgbm,
  libGLU,
  libx11,
  libxmu,
  libxext,
  libxi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sndpeek";
  version = "1.41";

  src = fetchurl {
    url = "https://soundlab.cs.princeton.edu/software/sndpeek/files/sndpeek-${finalAttrs.version}.tgz";
    hash = "sha256-ZVMLZRDQfCCI5f+i5LEb34uHKqiTkT2pa2sBjnSyTk0=";
  };

  patches = [
    # this patch adds -lpthread to the list of libraries, without it a
    # symbol-not-found-error is thrown
    ./pthread.patch
    # fix error: reference to 'complex' is ambiguous
    ./ambiguous-complex.patch
  ];

  postPatch = ''
    cd "src/sndpeek"
  '';

  buildInputs = [
    libglut
    alsa-lib
    libgbm
    libGLU
    libsndfile
    libx11
    libxmu
    libxext
    libxi
  ];
  buildFlags = [ "linux-alsa" ];

  installPhase = ''
    mkdir -p $out/bin
    mv sndpeek $out/bin
  '';

  meta = {
    description = "Real-time 3D animated audio display/playback";
    longDescription = ''
      sndpeek is just what it sounds (and looks) like:
        * real-time 3D animated display/playback
        * can use mic-input or wav/aiff/snd/raw/mat file (with playback)
        * time-domain waveform
        * FFT magnitude spectrum
        * 3D waterfall plot
        * lissajous! (interchannel correlation)
        * rotatable and scalable display
        * freeze frame! (for didactic purposes)
        * real-time spectral feature extraction (centroid, rms, flux, rolloff)
        * available on MacOS X, Linux, and Windows under GPL
        * part of the sndtools distribution.
    '';
    homepage = "https://soundlab.cs.princeton.edu/software/sndpeek/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.laikq ];
    mainProgram = "sndpeek";
  };
})
