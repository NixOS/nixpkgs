{
  lib,
  python3,
  fetchFromGitHub,
  asciinema,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "asciinema-automation";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PierreMarchand20";
    repo = "asciinema_automation";
    rev = "v${version}";
    hash = "sha256-SjUsPrhoNz2NTPAkmUH0Csv6hbDc6nyKdckGqV5S3GY=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    asciinema
    pexpect
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      mypy
      pytest
      ruff
      types-pexpect
    ];
  };

  pythonImportsCheck = [ "asciinema_automation" ];

  meta = {
    changelog = "https://github.com/PierreMarchand20/asciinema_automation/blob/${src.rev}/CHANGELOG.md";
    description = "CLI utility to automate asciinema recordings";
    homepage = "https://github.com/PierreMarchand20/asciinema_automation";
    license = lib.licenses.mit;
    mainProgram = "asciinema-automation";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
