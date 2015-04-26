{ stdenv, qt4, boost, protobuf, mumble
, avahi, libcap, pkgconfig
, iceSupport ? false
, zeroc_ice ? null
}:

assert iceSupport -> zeroc_ice != null;

let
  optional = stdenv.lib.optional;
  optionalString = stdenv.lib.optionalString;
in
stdenv.mkDerivation rec {
  name = "murmur-${version}";

  inherit (mumble) version src;

  patchPhase = optional iceSupport ''
    sed -i 's,/usr/share/Ice/,${zeroc_ice}/,g' src/murmur/murmur.pro
  '';

  configurePhase = ''
    qmake CONFIG+=no-client CONFIG+=no-embed-qt \
    ${optionalString (!iceSupport) "CONFIG+=no-ice"}
  '';

  buildInputs = [ qt4 boost protobuf avahi libcap pkgconfig ]
    ++ optional iceSupport [ zeroc_ice ];

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
