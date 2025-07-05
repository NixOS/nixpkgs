{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "norminette";
  version = "3.3.58";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "42School";
    repo = "norminette";
    tag = version;
    hash = "sha256-6hBBbfW2PQFb8rcDihvtWK0df7WcvOk0il1E82GOxaU=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  preCheck = ''
    export PYTHONPATH=norminette:$PYTHONPATH
  '';

  meta = with lib; {
    description = "Open source norminette to apply 42's norme to C files";
    mainProgram = "norminette";
    homepage = "https://github.com/42School/norminette";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
