{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pyrosimple
, python3
, testers
, withInotify ? stdenv.isLinux
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyrosimple";
  version = "2.13.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kannibalox";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-e69e1Aa10/pew1UZBCIPIH3BK7I8C3HiW59fRuSZlkc=";
  };

  pythonRelaxDeps = [
    "prometheus-client"
    "python-daemon"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bencode-py
    apscheduler
    jinja2
    python-daemon
    importlib-resources
    parsimonious
    prometheus-client
    prompt-toolkit
    requests
    shtab
    python-box
    tomli-w
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ] ++ lib.optional withInotify inotify;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      package = pyrosimple;
      command = "pyroadmin --version";
    };
  };

  meta = with lib; {
    description = "RTorrent client";
    homepage = "https://kannibalox.github.io/pyrosimple/";
    changelog = "https://github.com/kannibalox/pyrosimple/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ne9z vamega ];
  };
}
