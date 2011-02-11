{ stdenv, fetchurl, qt4, libvorbis, boost, speechd, protobuf, libsndfile,
 avahi }:
        
throw "It does not build still. It wants a g15daemon header file or so"

stdenv.mkDerivation rec {
  name = "mumble-" + version;
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/mumble/${name}.tar.gz";
    sha256 = "1s4vlkdfmyzx7h3i4060q0sf2xywl9sm6dpjhaa150blbcylwmic";
  };

  patchPhase = ''
    sed -e s/qt_ja_JP.qm// -i src/mumble/mumble.pro src/mumble11x/mumble11x.pro
    sed -e /qt_ja_JP.qm/d -i src/mumble/mumble_qt.qrc src/mumble11x/mumble_qt.qrc
  '';

  configurePhase = "qmake PREFIX=$out";

  buildInputs = [ qt4 libvorbis boost speechd protobuf libsndfile avahi ];

  meta = { 
    homepage = http://mumble.sourceforge.net/;
    description = "Low-latency, high quality voice chat software";
    license = "BSD";
  };
}
