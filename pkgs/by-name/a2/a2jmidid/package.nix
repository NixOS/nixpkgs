{
  lib,
  stdenv,
  fetchFromGitea,
  makeWrapper,
  pkg-config,
  alsa-lib,
  dbus,
  libjack2,
  python3Packages,
  meson,
  ninja,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "a2jmidid";
  version = "12";

  src = fetchFromGitea {
    domain = "gitea.ladish.org";
    owner = "LADI";
    repo = "a2jmidid";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-PZKGhHmPMf0AucPruOLB9DniM5A3BKdghFCrd5pTzeM=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
  ];
  buildInputs = [
    alsa-lib
    dbus
    libjack2
  ]
  ++ (with python3Packages; [
    python
    dbus-python
  ]);

  postInstall = ''
    wrapProgram $out/bin/a2j_control --set PYTHONPATH $PYTHONPATH
    substituteInPlace $out/bin/a2j --replace "a2j_control" "$out/bin/a2j_control"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system";
    homepage = "https://a2jmidid.ladish.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
