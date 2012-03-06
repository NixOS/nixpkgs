{ stdenv, fetchurl, scons, boost, pkgconfig, fftw, librdf_raptor
, librdf_rasqal, jackaudio, flac, libsamplerate, alsaLib, libxml2
, libxslt, libsndfile, libsigcxx, libusb, cairomm, glib, pango
, gtk, glibmm, gtkmm, libgnomecanvas, librdf, liblo, aubio
, fftwSinglePrec, libmad }:

stdenv.mkDerivation {
  name = "ardour-2.8.2";

  # svn is the source to get official releases from their site?
  # alternative: wget  --data-urlencode 'key=7c4b2e1df903aae5ff5cc4077cda801e' http://ardour.org/downloader
  # but hash is changing ?
  src = fetchurl {
    url = http://mawercer.de/~nix/ardour-2.8.2.tar.bz2;
    sha256 = "1igwv1r6rlybdac24qady5asaf34f9k7kawkkgyvsifhl984m735";
  };

  buildInputs = [
    scons boost pkgconfig fftw librdf_raptor librdf_rasqal jackaudio
    flac libsamplerate alsaLib libxml2 libxslt libsndfile libsigcxx
    libusb cairomm glib pango gtk glibmm gtkmm libgnomecanvas librdf
    liblo aubio fftwSinglePrec libmad
  ];

  buildPhase = ''
    mkdir -p $out
    export CXX=g++
    scons PREFIX=$out install
  '';
  
  installPhase = ":";

  meta = { 
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Also read "The importance of Paying Something" on their homepage, please!
    '';
    homepage = http://ardour.org/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
