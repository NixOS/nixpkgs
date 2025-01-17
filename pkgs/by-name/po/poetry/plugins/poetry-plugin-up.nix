{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  pytestCheckHook,
  pytest-mock,
  poetry,
}:

buildPythonPackage rec {
  pname = "poetry-plugin-up";
  version = "0.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "MousaZeidBaker";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-PWHbMDGL9CGLRmvFWLOztUW0f/TJioPjQtAgpyCbAqw=";
  };

  build-system = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Poetry plugin to simplify package updates";
    homepage = "https://github.com/MousaZeidBaker/poetry-plugin-up";
    changelog = "https://github.com/MousaZeidBaker/poetry-plugin-up/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.k900 ];
    # https://github.com/MousaZeidBaker/poetry-plugin-up/pull/70
    broken = lib.versionAtLeast poetry.version "2";
  };
}
