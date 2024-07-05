{
  lib,
  python3,
  fetchFromGitHub,
  imagemagick,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pywal16";
  version = "3.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "pywal16";
    rev = "refs/tags/${version}";
    hash = "sha256-14xl0E4zpUCjW8rkqWA87TGsDy8lgqOQm9GeE9JIsVk=";
  };

  nativeBuildInputs = [ python3.pkgs.setuptools ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    imagemagick
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "pywal" ];

  meta = {
    description = "16 colors fork of pywal";
    homepage = "https://github.com/eylles/pywal16";
    changelog = "https://github.com/eylles/pywal16/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "wal";
  };
}
