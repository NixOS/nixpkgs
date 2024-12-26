{
  lib,
  fetchFromGitHub,
  coreutils,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "compiledb";
  version = "0.10.1";
  pyproject = true;

  build-system = [ python3Packages.setuptools ];

  src = fetchFromGitHub {
    owner = "nickdiego";
    repo = "compiledb";
    rev = "refs/tags/v${version}";
    hash = "sha256-pN2F0bFT5r8w+8kZOP/tU7Cx1SDN81fzkMfnj19jMWM=";
  };

  dependencies = with python3Packages; [
    click
    bashlex
    shutilwhich
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
