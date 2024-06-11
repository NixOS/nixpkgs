{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pre2k";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garrettfoster13";
    repo = "pre2k";
    rev = "refs/tags/${version}";
    hash = "sha256-z1ttuRos7x/zdWiYYozxWzRarFExd4W5rUYAEiUMugU=";
  };

  pythonRelaxDeps = [
    "impacket"
    "pyasn1"
    "rich"
    "typer"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    ldap3
    pyasn1
    rich
    typer
  ];

  pythonImportsCheck = [
    "pre2k"
  ];

  meta = with lib; {
    description = "Tool to query for the existence of pre-windows 2000 computer objects";
    homepage = "https://github.com/garrettfoster13/pre2k";
    changelog = "https://github.com/garrettfoster13/pre2k/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pre2k";
  };
}
