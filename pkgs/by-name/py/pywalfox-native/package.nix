{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pywalfox-native";
  version = "2.7.4";

  src = fetchPypi {
    inherit version;
    pname = "pywalfox";
    hash = "sha256-Wec9fic4lXT7gBY04D2EcfCb/gYoZcrYA/aMRWaA7WY=";
  };

  pythonImportsCheck = [ "pywalfox" ];

  meta = with lib; {
    homepage = "https://github.com/Frewacom/pywalfox-native";
    description = "Native app used alongside the Pywalfox addon";
    mainProgram = "pywalfox";
    license = licenses.mpl20;
    maintainers = with maintainers; [ tsandrini ];
  };
}
