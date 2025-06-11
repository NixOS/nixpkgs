{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opentimestamps-client";
  version = "0.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "opentimestamps-client";
    tag = "opentimestamps-client-v${version}";
    hash = "sha256-ny2svB8WcoUky8UfeilANo1DlS+f3o9RtV4YNmUwjJk=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    gitpython
    opentimestamps
    pysocks
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "otsclient"
  ];

  meta = with lib; {
    description = "Command-line tool to create and verify OpenTimestamps proofs";
    mainProgram = "ots";
    homepage = "https://github.com/opentimestamps/opentimestamps-client";
    changelog = "https://github.com/opentimestamps/opentimestamps-client/releases/tag/opentimestamps-client-v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
