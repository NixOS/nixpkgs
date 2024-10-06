{ lib
, python3
, fetchFromGitHub
, fetchPypi

, python3Packages
}:

let
  prezzemolo = python3.pkgs.buildPythonPackage rec {
    pname = "prezzemolo";
    version = "0.0.4";
    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-0/SOHpOLSGTzuuinxTzFs6POShIrnMUbA95chaWgErU=";
    };
  };

  pyexcel-ezodf = python3.pkgs.buildPythonPackage rec {
    pname = "pyexcel-ezodf";
    version = "0.3.4";
    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-ly7uqbDkurYN/FzctzeMx7peBwoLcoJ0bAGCxd4BH/E=";
    };

    propagatedBuildInputs = with python3Packages; [
      wheel
      lxml
      nose
    ];
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "rp2";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eprbell";
    repo = "rp2";
    rev = version;
    hash = "sha256-lNi2BBOZ5jX4NVufen0d+h2VZEwT51+B6nwM2xLPo7M=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
   babel
   jsonschema
   prezzemolo
   python-dateutil
   pyexcel-ezodf
  ];

  meta = with lib; {
    description = "Privacy-focused, free, open-source cryptocurrency tax calculator for multiple countries";
    longDescription = ''
      Privacy-focused, free, open-source cryptocurrency tax calculator for
      multiple countries: it handles multiple coins/exchanges and computes
      long/short-term capital gains, cost bases, in/out lot
      relationships/fractioning, and account balances. It supports FIFO and it
      generates output in form 8949 format. It has a programmable plugin
      architecture.
    '';
    homepage = "https://github.com/eprbell/rp2";
    license = licenses.asl20;
    mainProgram = "rp2";
    platforms = platforms.linux;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

