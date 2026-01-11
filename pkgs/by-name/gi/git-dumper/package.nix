{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-dumper";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arthaud";
    repo = "git-dumper";
    tag = version;
    hash = "sha256-XU+6Od+mC8AV+w7sd8JaMB2Lc81ekeDLDiGGNu6bU0A=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
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
    description = "Tool to dump a git repository from a website";
    homepage = "https://github.com/arthaud/git-dumper";
    changelog = "https://github.com/arthaud/git-dumper/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yechielw ];
    mainProgram = "git-dumper";
  };
}
