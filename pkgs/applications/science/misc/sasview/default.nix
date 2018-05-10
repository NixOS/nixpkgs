{lib, fetchgit, gcc, python}:

let
  xhtml2pdf = import ./xhtml2pdf.nix { inherit lib;
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
  version = "4.1.2";

  buildInputs = with python.pkgs; [
    pytest
    unittest-xml-reporting];

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
    xhtml2pdf];

  src = fetchgit {
    url = "https://github.com/SasView/sasview.git";
    rev = "v${version}";
    sha256 ="05la54wwzzlkhmj8vkr0bvzagyib6z6mgwqbddzjs5y1wd48vpcx";
  };

  patches = [./pyparsing-fix.patch ./local_config.patch];

  meta = {
    homepage = https://www.sasview.org;
    description = "Fitting and data analysis for small angle scattering data";
    maintainers = with lib.maintainers; [ rprospero ];
    license = lib.licenses.bsd3;
  };
}
