{
  lib,
  python3,
  fetchFromGitHub,
  imagemagick,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pywal16";
  version = "3.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "pywal16";
    rev = "refs/tags/${version}";
    hash = "sha256-XDOmpeONPW6b1ZEGk272wwraTLR8PjjniIXm0M9BGU4=";
  };

  build-system = [ python3.pkgs.setuptools ];

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
