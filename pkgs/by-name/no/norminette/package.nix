{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "norminette";
  version = "3.3.59";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "42School";
    repo = "norminette";
    tag = version;
    hash = "sha256-XPaMQCziL9/h+AHx6I6MIRAlzscWvOTkxUP9dMI4y0o=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  pythonRemoveDeps = [
    # Can be removed once https://github.com/42school/norminette/issues/565 is addressed
    "argparse"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "norminette" ];

  meta = with lib; {
    description = "Open source norminette to apply 42's norme to C files";
    mainProgram = "norminette";
    homepage = "https://github.com/42School/norminette";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
