{ stdenv
, mkDerivation
, lib
, fetchzip
, pkgconfig
, qtbase
, makeWrapper
, python3Packages
}:

 mkDerivation rec {
  version = "0.9.0";
  pname = "cadence";

  src = fetchzip {
    url = "https://github.com/falkTX/Cadence/archive/v${version}.tar.gz";
    sha256 = "08vcggypkdfr70v49innahs5s11hi222dhhnm5wcqzdgksphqzwx";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    qtbase
  ];

  makeFlags = [
    "PREFIX=''"
    "DESTDIR=${placeholder "out"}"
  ];

  propagatedBuildInputs = with python3Packages; [
    pyqt5_with_qtwebkit
  ];

  dontWrapQtApps = true;

  # Replace with our own wrappers. They need to be changed manually since it wouldn't work otherwise.
  preFixup = let
    outRef = placeholder "out";
    prefix = "${outRef}/share/cadence/src";
    scriptAndSource = lib.mapAttrs' (script: source:
      lib.nameValuePair ("${outRef}/bin/" + script) ("${prefix}/" + source)
    ) {
      "cadence" = "cadence.py";
      "claudia" = "claudia.py";
      "catarina" = "catarina.py";
      "catia" = "catia.py";
      "cadence-jacksettings" = "jacksettings.py";
      "cadence-aloop-daemon" = "cadence_aloop_daemon.py";
      "cadence-logs" = "logs.py";
      "cadence-render" = "render.py";
      "claudia-launcher" = "claudia_launcher.py";
      "cadence-session-start" = "cadence_session_start.py";
    };
  in lib.mapAttrsToList (script: source: ''
    rm -f ${script}
    makeWrapper ${python3Packages.python.interpreter} ${script} \
      --set PYTHONPATH "$PYTHONPATH:${outRef}/share/cadence" \
      ''${qtWrapperArgs[@]} \
      --add-flags "-O ${source}"
  '') scriptAndSource;

  meta = {
    homepage = https://github.com/falkTX/Cadence/;
    description = "Collection of tools useful for audio production";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ genesis worldofpeace ];
    platforms = [ "x86_64-linux" ];
  };
}
