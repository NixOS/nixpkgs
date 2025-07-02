{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mongoaudit";
  version = "0.1.1";
  format = "setuptools";

  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stampery";
    repo = "mongoaudit";
    rev = version;
    sha256 = "17k4vw5d3kr961axl49ywid4cf3n7zxvm885c4lv15w7s2al1425";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pymongo
    setuptools
    urwid
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mongoaudit"
  ];

  meta = with lib; {
    description = "MongoDB auditing and pentesting tool";
    homepage = "https://github.com/stampery/mongoaudit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "mongoaudit";
  };
}
