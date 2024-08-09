{
  lib,
  stdenv,
  fetchFromGitLab,
  portaudio,
  boost,
  ganv,
  gtkmm2,
  libjack2,
  lilv,
  pkg-config,
  python3,
  raul,
  sord,
  sratom,
  suil,
  meson,
  ninja,
}:

stdenv.mkDerivation {
  pname = "ingen";
  version = "0-unstable-2024-07-13";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "ingen";
    rev = "bbdab98ed282291b6e29a944359c360c9cca127e";
    hash = "sha256-BllWeVmEkHQaZD9Ba7H0JMRlxVROJ8pkIiC2VXYiweA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    boost
    ganv
    gtkmm2
    libjack2
    lilv
    portaudio
    raul
    sord
    sratom
    suil
  ];

  strictDeps = true;

  # lv2specgen.py is not packaged in lv2 but required to build docs
  mesonFlags = [ "-Ddocs=disabled" ];

  pythonPath = [
    python3
    python3.pkgs.rdflib
  ];

  postInstall = ''
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
    wrapProgram "$out/bin/ingen" --set INGEN_UI_PATH "$out/share/ingen/ingen_gui.ui"
  '';

  meta = {
    description = "Modular audio processing system using JACK and LV2 or LADSPA plugins";
    homepage = "http://drobilla.net/software/ingen";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.linux;
  };
}
