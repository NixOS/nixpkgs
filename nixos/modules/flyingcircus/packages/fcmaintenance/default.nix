{ pkgs ? import <nixpkgs> { }
, python34Packages ? pkgs.python34Packages
, fcutil ? import ../fcutil { pkgs = pkgs; }
}:

let
  py = python34Packages;

  pytestcatchlog = py.buildPythonPackage rec {
    name = "pytest-catchlog-${version}";
    version = "1.2.2";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/p/pytest-catchlog/pytest-catchlog-1.2.2.zip;
      md5 = "09d890c54c7456c818102b7ff8c182c8";
    };
    propagatedBuildInputs = with py; [pytest];
    dontStrip = true;
  };

  freezegun = py.buildPythonPackage rec {
    name = "freezegun-${version}";
    version = "0.3.6";
    src = pkgs.fetchurl {
      url = https://pypi.python.org/packages/source/f/freezegun/freezegun-0.3.6.tar.gz;
      md5 = "c321cf7392343f91e524eec0b601e8ec";
    };
    propagatedBuildInputs = with py; [dateutil];
    dontStrip = true;
  };

in
  py.buildPythonPackage rec {
    name = "fc-maintenance-${version}";
    version = "2.0";
    namePrefix = "";
    src = ./.;
    propagatedBuildInputs =
      [ fcutil
        py.iso8601
        py.pytz
        py.pyyaml
        py.shortuuid
      ];
    buildInputs = with py;
      [ freezegun
        pytest
        pytestcatchlog
        pytestcov
      ];
    checkPhase = ''
      export PYTHONPATH=".:$PYTHONPATH"
      py.test -x fc/maintenance
    '';
    dontStrip = true;
  }
