{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "soco-cli";
  version = "0.4.73";
  format = "setuptools";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "avantrec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WxBwHjh5tCXclQXqrHrpvZdcQU93RObteAfZyyVvKf0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    fastapi
    rangehttpserver
    soco
    tabulate
    uvicorn
  ];

  # Tests wants to communicate with hardware
  doCheck = false;

  pythonImportsCheck = [
    "soco_cli"
  ];

  meta = {
    description = "Command-line interface to control Sonos sound systems";
    homepage = "https://github.com/avantrec/soco-cli";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "sonos";
    maintainers = with lib.maintainers; [ fab ];
  };
}
