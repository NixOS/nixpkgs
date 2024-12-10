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
  version = "0.7.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "MousaZeidBaker";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yhGoiuqPUzEPiq+zO/RD4pB1LvOo80yLIpM+rRQHOmY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    poetry
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
  };
}
