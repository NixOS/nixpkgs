{ lib, fetchPypi, fetchurl, python3Packages }:

let
  inherit (python3Packages) buildPythonPackage;

  reprint = buildPythonPackage rec {
    pname = "reprint";
    version = "0.6.0";
    src = fetchurl {
      url =
        "https://files.pythonhosted.org/packages/ab/30/a742e69e37d4148dfa89acb6aa2a82ea298d1dfea02c6e9b2a43d4ed1065/reprint-0.6.0-py2.py3-none-any.whl";
      hash = "sha256-DrxNwhrvyBAgXz/MIXg+qRu5YpKoUAZjSC6GSYm/9U0=";
    };
    format = "wheel";
  };

  verilogae = buildPythonPackage rec {
    pname = "verilogae";
    version = "1.0.0";
    src = fetchurl {
      url =
        "https://files.pythonhosted.org/packages/aa/a6/9daea00745844faba44c2917c66838adfc315269f38518ecca49e6eb5fb5/verilogae-1.0.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      hash = "sha256-QsEVq/4c44xCkovOhXOj8Zh6rp4Ipq+NGjbTW25Fd6E=";
    };
    format = "wheel";
  };

in buildPythonPackage rec {
  pname = "DMT_core";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-489E+uNn4NgyCwxsUMEPH/1ZuM+5uNq4zx8F88rkHMU=";
  };
  doCheck = false;

  propagatedBuildInputs = [
    python3Packages.colorama
    python3Packages.colormath
    python3Packages.cycler
    python3Packages.h5py
    python3Packages.joblib
    python3Packages.matplotlib
    python3Packages.more-itertools
    python3Packages.packaging
    python3Packages.pandas
    python3Packages.pint
    python3Packages.pyarrow
    python3Packages.pyqtgraph
    python3Packages.pyyaml
    python3Packages.requests
    python3Packages.scikit-rf
    python3Packages.scipy
    python3Packages.semver
    python3Packages.setuptools
    reprint
    verilogae
  ];

  nativeCheckInputs = [ python3Packages.pytest ];

  meta = {
    changelog =
      "https://gitlab.com/dmt-development/dmt-core/-/blob/Version_${version}/CHANGELOG?ref_type=tags";
    description =
      "Python tool to help modeling engineers extract model parameters, run circuit and TCAD simulations and automate infrastructure";
    homepage = "https://gitlab.com/dmt-development/dmt-core";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jasonodoom ];
    platforms = lib.platforms.linux;
  };
}
