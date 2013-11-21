{ stdenv, fetchurl, qt4, boost, speechd, protobuf, libsndfile,
 speex, libopus, avahi, pkgconfig
jackSupport ? false, 
jackaudio ? null }:


stdenv.mkDerivation rec {
  name = "mumble-" + version;
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/mumble/${name}.tar.gz";
    sha256 = "16wwj6gwcnyjlnzh7wk0l255ldxmbwx0wi652sdp20lsv61q7kx1";
  };

  patchPhase = ''
    patch -p1 < ${ ./mumble-jack-support.patch }
  '';

  configurePhase = ''
    qmake CONFIG+=no-g15 CONFIG+=no-update CONFIG+=no-server \
      CONFIG+=no-embed-qt-translations CONFIG+=packaged \
      CONFIG+=bundled-celt CONFIG+=no-bundled-opus \
      CONFIG+=no-bundled-speex
  '' 
  + stdenv.lib.optionalString jackSupport ''
    CONFIG+=no-oss CONFIG+=no-alsa CONFIG+=jackaudio
  '';


  buildInputs = [ qt4 boost speechd protobuf libsndfile speex
    libopus avahi pkgconfig ]
    ++ (stdenv.lib.optional jackSupport jackaudio);

  installPhase = ''
    mkdir -p $out
    cp -r ./release $out/bin
  '';

  meta = { 
    homepage = http://mumble.sourceforge.net/;
    description = "Low-latency, high quality voice chat software";
    license = "BSD";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
