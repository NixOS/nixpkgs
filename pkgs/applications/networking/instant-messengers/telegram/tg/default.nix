{ lib, buildPythonApplication, fetchFromGitHub, pythonOlder, python-telegram }:

buildPythonApplication rec {
  pname = "tg";
  version = "0.19.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "paul-nameless";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-apHd26XnOz5nak+Kz8PJPsonQfTWDyPz7Mi/tWf7zwM=";
  };

  propagatedBuildInputs = [ python-telegram ];

  doCheck = false; # No tests

  meta = with lib; {
    description = "Terminal client for telegram";
    homepage = "https://github.com/paul-nameless/tg";
    license = licenses.unlicense;
    maintainers = with maintainers; [ sikmir ];
  };
}
