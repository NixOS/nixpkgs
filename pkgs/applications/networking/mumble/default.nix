{ stdenv, fetchurl, qt4, libvorbis, boost, speechd, protobuf, libsndfile,
 avahi, dbus, libcap, pkgconfig,
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
    qmake CONFIG+=no-g15 CONFIG+=no-update \
      CONFIG+=no-embed-qt-translations CONFIG+=no-ice \
  '' 
  + stdenv.lib.optionalString jackSupport ''
    CONFIG+=no-oss CONFIG+=no-alsa CONFIG+=jackaudio
  '';


  buildInputs = [ qt4 libvorbis boost speechd protobuf libsndfile avahi dbus
    libcap pkgconfig ]
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
