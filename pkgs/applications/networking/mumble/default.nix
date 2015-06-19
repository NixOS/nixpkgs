{ stdenv, fetchurl, pkgconfig
, avahi, boost, libopus, libsndfile, protobuf, qt4, speex
, jackSupport ? false, libjack2 ? null
, speechdSupport ? false, speechd ? null
, pulseSupport ? false, libpulseaudio ? null
}:

assert jackSupport -> libjack2 != null;
assert speechdSupport -> speechd != null;
assert pulseSupport -> libpulseaudio != null;

let
  optional = stdenv.lib.optional;
  optionalString = stdenv.lib.optionalString;
in
stdenv.mkDerivation rec {
  name = "mumble-${version}";
  version = "1.2.9";

  src = fetchurl {
    url = "mirror://sourceforge/mumble/${name}.tar.gz";
    sha256 = "1frc6b284cl36czrsrg47mnmg1im0pjqscp877gz2rrjc62pxlab";
  };

  patches = optional jackSupport ./mumble-jack-support.patch;

  configureFlags = [
    "CONFIG+=shared"
    "CONFIG+=no-g15"
    "CONFIG+=packaged"
    "CONFIG+=no-update"
    "CONFIG+=no-server"
    "CONFIG+=no-embed-qt-translations"
    "CONFIG+=bundled-celt"
    "CONFIG+=no-bundled-opus"
    "CONFIG+=no-bundled-speex"
  ] ++ optional (!speechdSupport) "CONFIG+=no-speechd"
    ++ optional jackSupport "CONFIG+=no-oss CONFIG+=no-alsa CONFIG+=jackaudio";

  configurePhase = ''
    qmake $configureFlags
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ avahi boost libopus libsndfile protobuf qt4 speex ]
    ++ optional jackSupport libjack2
    ++ optional speechdSupport speechd
    ++ optional pulseSupport libpulseaudio;

  installPhase = ''
    mkdir -p $out
    cp -r ./release $out/bin

    mkdir -p $out/share/applications
    cp scripts/mumble.desktop $out/share/applications

    mkdir -p $out/share/icons
    cp icons/mumble.svg $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "Low-latency, high quality voice chat software";
    homepage = "http://mumble.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
