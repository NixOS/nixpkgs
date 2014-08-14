{ stdenv, fetchgit, alsaLib, cmake, gtk, jack2, libgnomecanvas
, libpthreadstubs, libsamplerate, libsndfile, libtool, libxml2
, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "petri-foo";

  src = fetchgit {
    url = https://github.com/licnep/Petri-Foo.git;
    rev = "eef3b6efebe842d2fa18ed32b881fea4562b84e0";
    sha256 = "a20c3f1a633500a65c099c528c7dc2405daa60738b64d881bb8f2036ae59913c";
  };

  buildInputs =
   [ alsaLib cmake  gtk jack2 libgnomecanvas libpthreadstubs
     libsamplerate libsndfile libtool libxml2 pkgconfig
   ];

  dontUseCmakeBuildDir=true;

  meta = with stdenv.lib; {
    description = "MIDI controllable audio sampler";
    longDescription = "a fork of Specimen";
    homepage = http://petri-foo.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
