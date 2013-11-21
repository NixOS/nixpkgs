{ stdenv, fetchurl, qt4, boost, protobuf, avahi, libcap, pkgconfig }:

stdenv.mkDerivation rec {
  name = "murmur-" + version;
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/mumble/mumble-${version}.tar.gz";
    sha256 = "16wwj6gwcnyjlnzh7wk0l255ldxmbwx0wi652sdp20lsv61q7kx1";
  };

  configurePhase = ''
    qmake CONFIG+=no-client CONFIG+=no-ice CONFIG+=no-embed-qt
  '';

  buildInputs = [ qt4 boost protobuf avahi libcap pkgconfig ];

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
