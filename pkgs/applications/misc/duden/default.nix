{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "duden";
  version = "0.18.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "radomirbosak";
    repo = "duden";
    rev = version;
    hash = "sha256-ZrarN09Znw4m6YiZxD7q7dTJ49WjmHDobLnOt8JCwvc=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    crayons
    pyxdg
    pyyaml
    requests
    setuptools
  ];

  pythonImportsCheck = [ "duden" ];

  meta = with lib; {
    description = "CLI for http://duden.de dictionary written in Python";
    homepage = "https://github.com/radomirbosak/duden";
    changelog = "https://github.com/radomirbosak/duden/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
