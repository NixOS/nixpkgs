{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

with python3.pkgs;
buildPythonApplication (finalAttrs: {
  pname = "poetry2conda";
  version = "0.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dojeda";
    repo = "poetry2conda";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UqNoEGgStvqtxhYwExk7wO4SvATaM2kGaFbB5ViJa7U=";
  };

  patches = [
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/dojeda/poetry2conda/commit/b127090498c89fbd8bbcbac45d03178a1e1c4219.patch";
      hash = "sha256-J26NhVPG1vD/QNXi5irtGW05CYsIYvZNQIi8YvHwCLc=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    poetry-semver
    toml
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    pyyaml
  ];

  meta = {
    description = "Script to convert a Python project declared on a pyproject.toml to a conda environment";
    homepage = "https://github.com/dojeda/poetry2conda";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "poetry2conda";
  };
})
