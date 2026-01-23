{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mud";
  version = "1.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jasursadikov";
    repo = "mud";
    tag = "v${version}";
    hash = "sha256-nYmMz91ElYZDelyHGAF6FlEhXqORODRgdLbxha4sUb8=";
  };

  build-system = with python3Packages; [
    hatchling
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    prettytable
  ];

  pythonImportsCheck = [ "mud" ];

  # Removed versionCheckHook due to conflict with the new release,
  # a mud config file is required to run the version check command.
  # Mud can only be initialized in a directory containing git repos.

  meta = {
    description = "Multi-directory git runner which allows you to run git commands in a multiple repositories";
    homepage = "https://github.com/jasursadikov/mud";
    license = lib.licenses.mit;
    changelog = "https://github.com/jasursadikov/mud/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "mud";
  };
}
