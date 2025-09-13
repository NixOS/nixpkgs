{
  lib,
  python3Packages,
  fetchFromGitHub,
  mopidy,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Tidal";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tehkillerbee";
    repo = "mopidy-tidal";
    tag = "v${version}";
    hash = "sha256-hUYT9c4bEPfUU3f2ywK0MO0jDDLmM+3hp17XH4XJQt8=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = [
    mopidy
    python3Packages.tidalapi
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
  ];

  enabledTestPaths = [ "tests/" ];

  meta = {
    description = "Mopidy extension for playing music from Tidal";
    homepage = "https://github.com/tehkillerbee/mopidy-tidal";
    changelog = "https://github.com/tehkillerbee/mopidy-tidal/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
