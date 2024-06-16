{ lib, buildPythonApplication, fetchurl, fetchPypi, pythonPackages }:

let
  reprint = buildPythonApplication rec {
    pname = "reprint";
    version = "0.6.0";
    src = fetchurl {
      url =
        "https://files.pythonhosted.org/packages/ab/30/a742e69e37d4148dfa89acb6aa2a82ea298d1dfea02c6e9b2a43d4ed1065/reprint-0.6.0-py2.py3-none-any.whl";
      sha256 = "DrxNwhrvyBAgXz/MIXg+qRu5YpKoUAZjSC6GSYm/9U0=";
    };
    format = "wheel";
  };

  verilogae = buildPythonApplication rec {
    pname = "verilogae";
    version = "1.0.0";
    src = fetchurl {
      url =
        "https://files.pythonhosted.org/packages/aa/a6/9daea00745844faba44c2917c66838adfc315269f38518ecca49e6eb5fb5/verilogae-1.0.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "QsEVq/4c44xCkovOhXOj8Zh6rp4Ipq+NGjbTW25Fd6E=";
    };
    format = "wheel";
  };

in buildPythonApplication rec {
  pname = "DMT_core";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "489E+uNn4NgyCwxsUMEPH/1ZuM+5uNq4zx8F88rkHMU=";
  };

  propagatedBuildInputs = [
    pythonPackages.joblib
    pythonPackages.pint
    pythonPackages.pyyaml
    pythonPackages.more-itertools
    pythonPackages.semver
    pythonPackages.h5py
    pythonPackages.cycler
    pythonPackages.colormath
    pythonPackages.colorama
    pythonPackages.scipy
    pythonPackages.scikit-rf
    pythonPackages.packaging
    pythonPackages.pandas
    pythonPackages.pyqtgraph
    pythonPackages.matplotlib
    pythonPackages.pyarrow
    pythonPackages.requests
    reprint
    verilogae
    pythonPackages.setuptools
  ];

  nativeCheckInputs = [ pythonPackages.pytest ];

  meta = with lib; {
    changelog =
      "https://gitlab.com/dmt-development/dmt-core/-/blob/Version_${version}/CHANGELOG?ref_type=tags";
    description =
      "DeviceModelingToolkit (DMT) is a Python tool targeted at helping modeling engineers extract model parameters, run circuit and TCAD simulations and automate their infrastructure.";
    homepage = "https://gitlab.com/dmt-development/dmt-core";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jasonodoom ];
    platforms = platforms.linux;
  };
}
