{
  fetchFromGitHub,
  git,
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "git-autoshare";
  version = "1.0.0b6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acsone";
    repo = "git-autoshare";
    rev = version;
    hash = "sha256-F8wcAayIR6MH8e0cQSwFJn/AVSLG3tVil80APjcFG/0=";
  };

  build-system = with python3Packages; [ setuptools-scm ];
  dependencies = with python3Packages; [
    appdirs
    click
    pyyaml
  ];

  # Tests require network
  doCheck = false;

  makeWrapperArgs = [ "--set-default GIT_AUTOSHARE_GIT_BIN ${lib.getExe git}" ];

  pythonImportsCheck = [ "git_autoshare" ];

  meta = {
    changelog = "https://github.com/acsone/git-autoshare/releases/tag/${version}";
    description = "Git clone wrapper that automatically uses --reference to save disk space and download time";
    homepage = "https://github.com/acsone/git-autoshare";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
