{
  lib,
  fetchFromGitHub,
  gitUpdater,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jefferson";
  version = "0.4.6";
  format = "pyproject";
  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "jefferson";
    rev = "v${version}";
    hash = "sha256-6eh4i9N3aArU8+W8K341pp9J0QYEojDiMrEc8yax4SY=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    cstruct
    lzallright
  ];

  pythonImportsCheck = [
    "jefferson"
  ];

  # upstream has no tests
  doCheck = false;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "JFFS2 filesystem extraction tool";
    homepage = "https://github.com/onekey-sec/jefferson";
    license = licenses.mit;
    maintainers = with maintainers; [
      tnias
      vlaci
    ];
    mainProgram = "jefferson";
  };
}
