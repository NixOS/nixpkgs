{ stdenv
, a2jmidid
, coreutils
, lib
, libjack2
, fetchpatch
, fetchzip
, jack_capture
, pkgconfig
, pulseaudioFull
, qtbase
, makeWrapper
, mkDerivation
, python3
}:
#ladish missing, claudia can't work.
#pulseaudio needs fixes (patchShebangs .pa ...)
#desktop needs icons and exec fixing.

mkDerivation rec {
  version = "0.9.1";
  pname = "cadence";

  src = fetchzip {
    url = "https://github.com/falkTX/Cadence/archive/v${version}.tar.gz";
    sha256 = "07z8grnnpkd0nf3y3r6qjlk1jlzrbhdrp9mnhrhhmws54p1bhl20";
  };

  patches = [
    # Fix installation without DESTDIR
    (fetchpatch {
      url = "https://github.com/falkTX/Cadence/commit/1fd3275e7daf4b75f59ef1f85a9e2e93bd5c0731.patch";
      sha256 = "0q791jsh8vmjg678dzhbp1ykq8xrrlxl1mbgs3g8if1ccj210vd8";
    })
  ];

  postPatch = ''
      libjackso=$(realpath ${lib.makeLibraryPath [libjack2]}/libjack.so.0);
      substituteInPlace ./src/jacklib.py --replace libjack.so.0 $libjackso
      substituteInPlace ./src/cadence.py --replace "/usr/bin/pulseaudio" \
        "${lib.makeBinPath[pulseaudioFull]}/pulseaudio"
      substituteInPlace ./c++/jackbridge/JackBridge.cpp --replace libjack.so.0 $libjackso
  '';

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    qtbase
    jack_capture
    pulseaudioFull
    ((python3.withPackages (ps: with ps; [
          pyqt5
          dbus-python
        ])))
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
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
    makeQtWrapper ${source} ${script} \
      --prefix PATH : "${lib.makeBinPath [
        jack_capture # cadence-render
        pulseaudioFull # cadence, cadence-session-start
        ]}"
  '') scriptAndSource;

  meta = {
    homepage = "https://github.com/falkTX/Cadence/";
    description = "Collection of tools useful for audio production";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ genesis worldofpeace ];
    platforms = [ "x86_64-linux" ];
  };
}
