args: with args;
stdenv.mkDerivation {
  name = "ardour-2.8.2";

  # svn is the source to get official releases from their site.. :-(
  src = /tmp/ardour-2.8.2.tar.bz2;

  buildInputs = [
    scons boost
    pkgconfig fftw redland librdf_raptor librdf_rasqal jackaudio flac
    libsamplerate alsaLib libxml2 libxslt libsndfile libsigcxx libusb cairomm
    glib pango gtk glibmm gtkmm libgnomecanvas fftw librdf liblo aubio
    fftw fftwSinglePrec libmad
  ];

  buildPhase = ''
    ensureDir $out
    export CXX=g++
    scons PREFIX=$out install
  '';
  installPhase = ":";

  meta = { 
    description = "multi-track hard disk recording software";
    longDescription = ''
      Also read "the importance of Paying Something on their homepage, pelase!"
    '';
    homepage = http://ardour.org/;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
