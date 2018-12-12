{ stdenv
, fetchzip
, pkgconfig
, qtbase
, makeWrapper
, jack2Full
, python3Packages
, a2jmidid
}:

 stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "cadence";

  src = fetchzip {
    url = "https://github.com/falkTX/Cadence/archive/v${version}.tar.gz";
    sha256 = "08vcggypkdfr70v49innahs5s11hi222dhhnm5wcqzdgksphqzwx";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ qtbase ];

  makeFlags = ''
    PREFIX=""
    DESTDIR=$(out)
  '';

  propagatedBuildInputs = with python3Packages; [ pyqt5_with_qtwebkit ];

  postInstall = ''
    # replace with our own wrappers. They need to be changed manually since it wouldn't work otherwise
    rm $out/bin/cadence
    makeWrapper ${python3Packages.python.interpreter} $out/bin/cadence \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/cadence.py"
    rm $out/bin/claudia
    makeWrapper ${python3Packages.python.interpreter} $out/bin/claudia \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/claudia.py"
    rm $out/bin/catarina
    makeWrapper ${python3Packages.python.interpreter} $out/bin/catarina \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/catarina.py"
    rm $out/bin/catia
    makeWrapper ${python3Packages.python.interpreter} $out/bin/catia \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/catia.py"
    rm $out/bin/cadence-jacksettings
    makeWrapper ${python3Packages.python.interpreter} $out/bin/cadence-jacksettings \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/jacksettings.py"
    rm $out/bin/cadence-aloop-daemon
    makeWrapper ${python3Packages.python.interpreter} $out/bin/cadence-aloop-daemon \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/cadence_aloop_daemon.py"
    rm $out/bin/cadence-logs
    makeWrapper ${python3Packages.python.interpreter} $out/bin/cadence-logs \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/logs.py"
    rm $out/bin/cadence-render
    makeWrapper ${python3Packages.python.interpreter} $out/bin/cadence-render \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/render.py"
    rm $out/bin/claudia-launcher
    makeWrapper ${python3Packages.python.interpreter} $out/bin/claudia-launcher \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/claudia_launcher.py"
    rm $out/bin/cadence-session-start
    makeWrapper ${python3Packages.python.interpreter} $out/bin/cadence-session-start \
      --set PYTHONPATH "$PYTHONPATH:$out/share/cadence" \
      --add-flags "-O $out/share/cadence/src/cadence_session_start.py"
  '';

  meta = {
    homepage = https://github.com/falkTX/Cadence/;
    description = "Collection of tools useful for audio production";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ genesis ];
    platforms = [ "x86_64-linux" ];
  };
}
