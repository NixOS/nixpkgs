{
  lib,
  fetchPypi,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mud-git";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "mud_git";
    inherit version;
    hash = "sha256-tf7FvBdr8Dg7R9lHUarkGxadnD6rxE1Yc/Y02DQDTLw=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    prettytable
  ];

  meta = {
    description = "Mud is a multi-directory git runner which allows you to run git commands in a multiple repositories";
    homepage = "https://pypi.org/project/mud-git/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "mud-git";
  };
}
