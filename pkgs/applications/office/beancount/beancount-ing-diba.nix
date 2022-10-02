{ lib
, stdenv
, fetchFromGitHub
, buildPythonApplication
, poetry
}:

buildPythonApplication rec {
  pname = "beancount-ing-diba";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "siddhantgoel";
    repo = "beancount-ing-diba";
    rev = "v${version}";
    sha256 = "sha256-1cdXqdeTz38n0g13EXJ1/IF/gJJCe1uL/Z5NJz4DL+E=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    poetry
  ];

  meta = with lib; {
    homepage = "https://github.com/siddhantgoel/beancount-ing-diba";
    description = "Beancount Importers for ING-DiBa (Germany) CSV Exports";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
