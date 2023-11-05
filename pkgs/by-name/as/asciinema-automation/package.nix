{ lib
, fetchPypi
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "asciinema-automation";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j6PQCVtz7fUcxhHEysFZfNwFKb5trmtEJ+cMzzjAVDc=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    pexpect
  ];

  meta = {
    description = "CLI utility to automate asciinema recordings";
    homepage = "https://github.com/PierreMarchand20/asciinema_automation";
    license = lib.licenses.mit;
    mainProgram = "asciinema-automation";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
