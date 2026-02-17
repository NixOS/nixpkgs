{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nextinspace";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "not-stirred";
    repo = "nextinspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CrhzCvIA3YAFsWvdemvK1RLMacsM5RtgMjLeiqz5MwY=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  pythonPath = with python3.pkgs; [
    requests
    tzlocal
    colorama
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-lazy-fixture
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
