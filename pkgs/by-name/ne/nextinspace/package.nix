{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nextinspace";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "not-stirred";
    repo = "nextinspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oEvRxaxx1pIco2+jm/3HUN0a0nqdo2VosCisM0MWTjU=";
  };

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    requests
    tzlocal
    colorama
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-lazy-fixtures
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "nextinspace"
  ];

  meta = {
    description = "Print upcoming space-related events in your terminal";
    mainProgram = "nextinspace";
    homepage = "https://github.com/The-Kid-Gid/nextinspace";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
