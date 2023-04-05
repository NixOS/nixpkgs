{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nextinspace";
  version = "2.0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "not-stirred";
    repo = pname;
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Print upcoming space-related events in your terminal";
    homepage = "https://github.com/The-Kid-Gid/nextinspace";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ penguwin ];
  };
}
