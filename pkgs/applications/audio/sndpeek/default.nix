{ stdenv, fetchurl, libsndfile, freeglut, alsaLib, mesa, libGLU, libX11, libXmu
, libXext, libXi }:

stdenv.mkDerivation rec {
  pname = "sndpeek";
  version = "1.4";

  src = fetchurl {
    url = "https://soundlab.cs.princeton.edu/software/sndpeek/files/sndpeek-${version}.tgz";
    sha256 = "2d86cf74854fa00dcdc05a35dd92bc4cf6115e87102b17023be5cba9ead8eedf";
  };
  sourceRoot = "sndpeek-${version}/src/sndpeek";

  # this patch adds -lpthread to the list of libraries, without it a
  # symbol-not-found-error is thrown
  patches = [ ./pthread.patch ];

  buildInputs = [
    freeglut
    alsaLib
    mesa
    libGLU
    libsndfile
    libX11
    libXmu
    libXext
    libXi
  ];
  buildFlags = [ "linux-alsa" ];

  installPhase = ''
    mkdir -p $out/bin
    mv sndpeek $out/bin
  '';

  meta = with stdenv.lib; {
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
    homepage = https://soundlab.cs.princeton.edu/software/sndpeek/;
    license = licenses.gpl2;
    maintainers = [ maintainers.laikq ];
  };
}
