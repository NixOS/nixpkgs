{ lib, fetchFromGitHub, gcc, python }:

let
  xhtml2pdf = import ./xhtml2pdf.nix {
    inherit lib;
    fetchPypi = python.pkgs.fetchPypi;
    buildPythonPackage = python.pkgs.buildPythonPackage;
    html5lib = python.pkgs.html5lib;
    httplib2 = python.pkgs.httplib2;
    nose = python.pkgs.nose;
    pillow = python.pkgs.pillow;
    pypdf2 = python.pkgs.pypdf2;
    reportlab = python.pkgs.reportlab;
  };

in

python.pkgs.buildPythonApplication rec {
  pname = "sasview";
  version = "4.2.0";

  checkInputs = with python.pkgs; [
    pytest
    unittest-xml-reporting
  ];

  checkPhase = ''
    # fix the following error:
    # imported module 'sas.sascalc.data_util.uncertainty' has this __file__ attribute:
    #   /build/source/build/lib.linux-x86_64-2.7/sas/sascalc/data_util/uncertainty.py
    # which is not the same as the test file we want to collect:
    #   /build/source/dist/tmpbuild/sasview/sas/sascalc/data_util/uncertainty.py
    rm -r dist/tmpbuild

    HOME=$(mktemp -d) py.test
  '';

  propagatedBuildInputs = with python.pkgs; [
    bumps
    gcc
    h5py
    libxslt
    lxml
    matplotlib
    numpy
    pyparsing
    periodictable
    pillow
    pylint
    pyopencl
    reportlab
    sasmodels
    scipy
    six
    sphinx
    wxPython
    xhtml2pdf
  ];

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasview";
    rev = "v${version}";
    sha256 = "0k3486h46k6406h0vla8h68fd78wh3dcaq5w6f12jh6g4cjxv9qa";
  };

  patches = [ ./pyparsing-fix.patch ./local_config.patch ];

  meta = with lib; {
    homepage = https://www.sasview.org;
    description = "Fitting and data analysis for small angle scattering data";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.bsd3;
  };
}
