{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pre2k";
  version = "3.0-unstable-2024-03-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garrettfoster13";
    repo = "pre2k";
    rev = "3baa7b73aedd45f52e417210081da3dd010c1b22";
    hash = "sha256-0lgH7Z9LuiZwODdFvKWcqS1TV02aVjzD9RgOhX0lU6s=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pre2k";
  };
}
