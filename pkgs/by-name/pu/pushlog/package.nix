{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "pushlog";
  version = "0.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "serpent213";
    repo = "pushlog";
    rev = "v${version}";
    sha256 = "sha256:1cfag0vfi07vnww5sls630xqc41rnyaqzrabia0fwhiill3k6dfm";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    fuzzywuzzy
    levenshtein
    pyyaml
    setuptools
    systemd
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Forward systemd journal to Pushover";
    longDescription = ''
      A lightweight Python daemon that filters and forwards journald log messages to Pushover
    '';
    homepage = "https://github.com/serpent213/pushlog";
    platforms = platforms.linux;
    mainProgram = "pushlog";
    license = licenses.bsd0;
    maintainers = with maintainers; [ serpent213 ];
  };
}
