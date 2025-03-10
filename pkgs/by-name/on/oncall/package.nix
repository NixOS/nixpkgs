{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "oncall";
  version = "2.1.7";
  format = "setuptools";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "linkedin";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-oqzU4UTpmAcZhqRilquxWQVyHv8bqq0AGraiSqwauiI=";
  };

  dependencies = with python3.pkgs; [
  ];

  pythonImportsCheck = [
    "oncall"
  ];

  meta = {
    description = "A calendar web-app designed for scheduling and managing on-call shifts";
    homepage = "http://oncall.tools";
    changelog = "https://github.com/linkedin/oncall/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "oncall";
  };
}
