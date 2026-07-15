{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pywalfox-native";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Frewacom";
    repo = "pywalfox-native";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8qMDwK4TgMqtGVGUnH3hyoyVlR3cQv28i7O4de+iuqU=";
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
})
