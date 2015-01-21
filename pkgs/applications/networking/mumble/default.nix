{ stdenv, fetchurl, qt4, boost, protobuf, libsndfile
, speex, libopus, avahi, pkgconfig
, jackSupport ? false
, jack2 ? null
, speechdSupport ? false
, speechd ? null
, pulseSupport ? false
, pulseaudio ? null
}:

assert jackSupport -> jack2 != null;
assert speechdSupport -> speechd != null;
assert pulseSupport -> pulseaudio != null;

let
  optional = stdenv.lib.optional;
  optionalString = stdenv.lib.optionalString;
in
stdenv.mkDerivation rec {
  name = "mumble-" + version;
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/mumble/${name}.tar.gz";
    sha256 = "0ng1xd7i0951kqnd9visf84y2dcwia79a1brjwfvr1wnykgw6bsc";
  };

  patches = optional jackSupport ./mumble-jack-support.patch;

  configurePhase = ''
    qmake CONFIG+=no-g15 CONFIG+=no-update CONFIG+=no-server \
      CONFIG+=no-embed-qt-translations CONFIG+=packaged \
      CONFIG+=bundled-celt CONFIG+=no-bundled-opus \
      ${optionalString (!speechdSupport) "CONFIG+=no-speechd"} \
      ${optionalString jackSupport "CONFIG+=no-oss CONFIG+=no-alsa CONFIG+=jackaudio"} \
      CONFIG+=no-bundled-speex
  '';


  buildInputs = [ qt4 boost protobuf libsndfile speex
    libopus avahi pkgconfig ]
    ++ (optional jackSupport jack2)
    ++ (optional speechdSupport speechd)
    ++ (optional pulseSupport pulseaudio);

  installPhase = ''
    mkdir -p $out
    cp -r ./release $out/bin
  '';

  meta = with stdenv.lib; { 
    homepage = "http://mumble.sourceforge.net/";
    description = "Low-latency, high quality voice chat software";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ viric ];
  };
}
