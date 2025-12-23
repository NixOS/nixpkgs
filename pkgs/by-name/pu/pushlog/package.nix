{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "pushlog";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serpent213";
    repo = "pushlog";
    tag = "v${version}";
    sha256 = "sha256-xlzEBSV6AKj24E/RZKksBnYQtNAaHZaff9p0K6Lxvco=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    fuzzywuzzy
    levenshtein
    pyyaml
    systemd
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    description = "Lightweight Python daemon that filters and forwards systemd journal to Pushover";
    homepage = "https://github.com/serpent213/pushlog";
    platforms = lib.platforms.linux;
    mainProgram = "pushlog";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ serpent213 ];
  };
}
