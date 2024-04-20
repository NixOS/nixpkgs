{ lib
, fetchFromGitHub
, python3
, expect
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ngrid";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twosigma";
    repo = "ngrid";
    rev = version;
    hash = "sha256-69icp0m+bAHBsQFIDGd8NjfMsMYsB1sUfzuP/OBl5jc=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.six
    python3.pkgs.numpy
    python3.pkgs.pytz
    python3.pkgs.pandas
  ];

  pythonImportsCheck = [ "ngrid.main" ];

  nativeCheckInputs = [ python3.pkgs.pytest expect ];
  checkPhase = ''
    runHook preCheck

    pytest test/formatters.py

    echo -e "a,b,c\n1.98423,some string,5824.2" > test.csv

    expect <<EOD
      exp_internal 1
      set timeout 3
      spawn $out/bin/ngrid test.csv

      expect {
        "Traceback" { exit 1 }
        timeout { }
      }

      send "q"

      expect {
        "Traceback" { exit 1 }
        eof { exit 0 }
      }
    EOD

    runHook postCheck
  '';

  meta = with lib; {
    description = "It's \"less\" for data";
    homepage = "https://github.com/twosigma/ngrid";
    license = licenses.bsd3;
    maintainers = with maintainers; [ twitchy0 ];
    mainProgram = "ngrid";
  };
}
