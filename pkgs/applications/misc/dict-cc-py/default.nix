{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "dict.cc.py";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rbaron";
    repo = "dict.cc.py";
    rev = "a8b469767590fdd15d3aeb0b00e2ae62aa15a918";
    hash = "sha256-wc0WY1pETBdOT3QUaVGsX8YdcnhxLIHrZ2vt2t5LYKU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    colorama
    requests
  ];

  pythonImportsCheck = [ "dictcc" ];

  meta = with lib; {
    description = "Unofficial command line client for dict.cc";
    homepage = "https://github.com/rbaron/dict.cc.py";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ ];
  };
}
