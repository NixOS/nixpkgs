{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "git-dumper";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arthaud";
    repo = "git-dumper";
    rev = version;
    hash = "sha256-XU+6Od+mC8AV+w7sd8JaMB2Lc81ekeDLDiGGNu6bU0A=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    dulwich
    pysocks
    requests
    requests-pkcs12
  ];

  pythonImportsCheck = [
    "git_dumper"
  ];

  meta = {
    description = "A tool to dump a git repository from a website";
    homepage = "https://github.com/arthaud/git-dumper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yechielw ];
    mainProgram = "git-dumper";
  };
}
