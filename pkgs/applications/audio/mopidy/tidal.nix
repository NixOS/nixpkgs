{
  lib,
  python3Packages,
  fetchFromGitHub,
  mopidy,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Tidal";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tehkillerbee";
    repo = "mopidy-tidal";
    rev = "v${version}";
    hash = "sha256-RFhuxsb6nQPYxkaeAEABQdCwjbmnOw5pnmYnx6gNCcg=";
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
    changelog = "https://github.com/tehkillerbee/mopidy-tidal/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
