{ stdenv
, fetchurl
, pkgconfig
, qtbase
, makeWrapper
, jack2Full
, python3Packages
, a2jmidid
}:

 stdenv.mkDerivation rec {
  version = "0.9.0";
  name = "cadence";

  src = fetchurl {
    url = "https://github.com/falkTX/Cadence/archive/v${version}.tar.gz";
    sha256 = "07z1mnb0bmldb3i31bgw816pnvlvr9gawr51rpx3mhixg5wpiqzb";
  };

  buildInputs = [
    makeWrapper
    pkgconfig
    qtbase
  ];

  apps = [
    "cadence"
    "cadence-jacksettings"
    "cadence-pulse2loopback"
    "claudia"
    "cadence-aloop-daemon"
    "cadence-logs"
    "cadence-render"
    "catarina"
    "claudia-launcher"
    "cadence-pulse2jack"
    "cadence-session-start"
    "catia"
  ];

  makeFlags = ''
    PREFIX=""
    DESTDIR=$(out)
  '';

  propagatedBuildInputs = with python3Packages; [ pyqt5 ];

  postInstall = ''
    # replace with our own wrappers.
    for app in $apps; do
      rm $out/bin/$app
      makeWrapper ${python3Packages.python.interpreter} $out/bin/$app \
        --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
        --add-flags "-O $out/share/cadence/src/$app.py"
    done
  '';

  meta = {
    homepage = https://github.com/falkTX/Cadence/;
    description = "Collection of tools useful for audio production";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ genesis ];
    platforms = stdenv.lib.platforms.linux;
  };
}
