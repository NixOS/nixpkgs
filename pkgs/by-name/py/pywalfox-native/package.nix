{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication {
  pname = "pywalfox-native";
  version = "2.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Frewacom";
    repo = "pywalfox-native";
    rev = "7ecbbb193e6a7dab424bf3128adfa7e2d0fa6ff9";
    hash = "sha256-i1DgdYmNVvG+mZiFiBmVHsQnFvfDFOFTGf0GEy81lpE=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  pythonImportsCheck = [ "pywalfox" ];

  meta = {
    homepage = "https://github.com/Frewacom/pywalfox-native";
    description = "Native app used alongside the Pywalfox addon";
    mainProgram = "pywalfox";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ tsandrini ];
  };
}
