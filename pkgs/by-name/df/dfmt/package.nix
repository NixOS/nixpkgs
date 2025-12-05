{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "dfmt";
  version = "1.2.0";
  format = "pyproject";
  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "your-tools";
    repo = "dfmt";
    tag = "v${version}";
    hash = "sha256-k1cKW5fNu+BS8roV8MNLlGSUHQ4WQXWT9OC4ZvS/oio=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace-fail "poetry>=0.12" "poetry-core>=1.0.0"
  '';

  build-system = [ python3Packages.poetry-core ];

  dontUsePythonRemoveTestsDir = true;
  nativeCheckInputs = [ python3Packages.pytest ];
  doCheck = true;
  checkPhase = ''
    pytest -vv test_dfmt.py
  '';

  meta = {
    description = "Format paragraphs, comments and doc strings";
    mainProgram = "dfmt";
    homepage = "https://github.com/your-tools/dfmt";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.cole-h ];
  };
}
