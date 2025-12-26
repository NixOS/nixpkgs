{
  lib,
  fetchFromGitHub,
  coreutils,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "compiledb";
  version = "0.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nickdiego";
    repo = "compiledb";
    tag = version;
    hash = "sha256-toqBf5q1EfZVhZN5DAtxkyFF7UlyNbqxWAIWFMwacxw=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    click
    bashlex
  ];

  # fix the tests
  patchPhase = ''
    substituteInPlace tests/data/multiple_commands_oneline.txt \
        --replace-fail "/bin/echo" "${coreutils}/bin/echo"
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  doCheck = true;

  meta = {
    description = "Tool for generating Clang's JSON Compilation Database files";
    mainProgram = "compiledb";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/nickdiego/compiledb";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
