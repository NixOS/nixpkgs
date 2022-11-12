{ lib
, libjack2
, fetchpatch
, fetchFromGitHub
, jack_capture
, pkg-config
, pulseaudioFull
, qtbase
, mkDerivation
, python3
}:
#ladish missing, claudia can't work.
#pulseaudio needs fixes (patchShebangs .pa ...)
#desktop needs icons and exec fixing.

mkDerivation rec {
  version = "0.9.1";
  pname = "cadence";

  src = fetchFromGitHub {
    owner = "falkTX";
    repo = "Cadence";
    rev = "v${version}";
    sha256 = "sha256-QFC4wiVF8wphhrammxtc+VMZJpXY5OGHs6DNa21+6B8=";
  };

  patches = [
    # Fix installation without DESTDIR
    (fetchpatch {
      url = "https://github.com/falkTX/Cadence/commit/1fd3275e7daf4b75f59ef1f85a9e2e93bd5c0731.patch";
      sha256 = "0q791jsh8vmjg678dzhbp1ykq8xrrlxl1mbgs3g8if1ccj210vd8";
    })
    # Fix build with Qt 5.15
    (fetchpatch {
      url = "https://github.com/falkTX/Cadence/commit/c167f35fbb76c4246c730b29262a59da73010412.patch";
      sha256 = "1gm9q6gx03sla5vcnisznc95pjdi2703f8b3mj2kby9rfx2pylyh";
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
    pkg-config
  ];

  buildInputs = [
    qtbase
    jack_capture
    pulseaudioFull
    (
      (python3.withPackages (ps: with ps; [
        pyqt5
        dbus-python
      ]))
    )
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  dontWrapQtApps = true;

  # Replace with our own wrappers. They need to be changed manually since it wouldn't work otherwise.
  preFixup =
    let
      outRef = placeholder "out";
      prefix = "${outRef}/share/cadence/src";
      scriptAndSource = lib.mapAttrs'
        (script: source:
          lib.nameValuePair ("${outRef}/bin/" + script) ("${prefix}/" + source)
        )
        {
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
    in
    lib.mapAttrsToList
      (script: source: ''
        rm -f ${script}
        makeQtWrapper ${source} ${script} \
          --prefix PATH : "${lib.makeBinPath [
            jack_capture # cadence-render
            pulseaudioFull # cadence, cadence-session-start
            ]}"
      '')
      scriptAndSource;

  meta = {
    homepage = "https://github.com/falkTX/Cadence/";
    description = "Collection of tools useful for audio production";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
