{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "arjun";
  version = "2.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "Arjun";
    tag = version;
    hash = "sha256-XEfCQEvRCvmNQ8yOlaR0nd7knhK1fQIrXEfQgrdVDrs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    dicttoxml
    ratelimit
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "arjun" ];

  meta = {
    description = "HTTP parameter discovery suite";
    homepage = "https://github.com/s0md3v/Arjun";
    changelog = "https://github.com/s0md3v/Arjun/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "arjun";
  };
}
