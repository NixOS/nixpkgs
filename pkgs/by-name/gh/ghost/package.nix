{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghost";
  version = "8.0.0";
  format = "pyproject";

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "EntySec";
    repo = "Ghost";
    rev = version;
    sha256 = "13p3inw7v55na8438awr692v9vb7zgf5ggxpha9r3m8vfm3sb4iz";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    adb-shell
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ghost" ];

  meta = with lib; {
    description = "Android post-exploitation framework";
    mainProgram = "ghost";
    homepage = "https://github.com/EntySec/ghost";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
