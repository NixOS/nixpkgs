{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "mud";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jasursadikov";
    repo = "mud";
    rev = "refs/tags/v${version}";
    hash = "sha256-pW4B4+RN7hKtG2enJ33OHBeGsLj8w20ylvjcOL6owAk=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    prettytable
  ];

  pythonImportsCheck = [ "mud" ];

  # Version checking fails on darwin with:
  # PermissionError: [Errno 1] Operation not permitted: '/var/empty/.mudsettings'
  # despite adding `export HOME=$(mktemp -d)` in the `preVersionCheck` phase.
  # The tool
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "multi-directory git runner which allows you to run git commands in a multiple repositories";
    homepage = "https://github.com/jasursadikov/mud";
    license = lib.licenses.mit;
    changelog = "https://github.com/jasursadikov/mud/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "mud";
  };
}
