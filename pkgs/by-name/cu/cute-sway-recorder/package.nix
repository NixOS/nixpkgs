{ lib
, python3
, fetchFromGitHub
, poetry
, poetryPlugins
, wf-recorder
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cute-sway-recorder";
  version = "0-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "it-is-wednesday";
    repo = "cute-sway-recorder";
    rev = "024ca32da63f4543cf3195ed8023749079f9aeb0";
    hash = "sha256-3VSpVehcCQsId3J4Sp3jNXZuTocHFCUVXCBXdDcvfvM=";
  };

  pyproject = true;

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    poetry
    poetryPlugins.poetry-plugin-export
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cachecontrol
    cleo
    dulwich
    fastjsonschema
    filelock
    keyring
    pexpect
    pkginfo
    platformdirs
    pyside6
    requests-toolbelt
    shellingham
    tomlkit
    trove-classifiers
    virtualenv
    wf-recorder
  ];

  pythonImportsCheck = [ "cute_sway_recorder" ];

  meta = with lib; {
    description = "SwayWM screen recorder; a GUI for wf-recorder";
    homepage = "https://github.com/it-is-wednesday/cute-sway-recorder";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "cute-sway-recorder";
    platforms = platforms.linux;
  };
}
