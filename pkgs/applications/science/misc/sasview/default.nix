{lib, fetchgit, gcc, python}:

let
  html5 = import ./myHtml5.nix {inherit python;};
  xhtml2pdf = import ./xhtml2pdf.nix {inherit python html5;};
in

python.pkgs.buildPythonApplication rec {
  name = "sasview-${version}";
  version = "4.1.2";

  propagatedBuildInputs = with python.pkgs; [
    bumps
    gcc
    h5py
    html5
    libxslt
    lxml
    matplotlib
    numpy
    pyparsing
    periodictable
    pillow
    pylint
    pyopencl
    pytest
    reportlab
    sasmodels
    scipy
    six
    sphinx
    unittest-xml-reporting
    wxPython
    xhtml2pdf];

  src = fetchgit {
    url = "https://github.com/SasView/sasview.git";
    rev = "v${version}";
    sha256 ="05la54wwzzlkhmj8vkr0bvzagyib6z6mgwqbddzjs5y1wd48vpcx";
  };

  patches = [./pyparsing-fix.patch ./local_config.patch];
  sandbox = true;

  meta = {
    homepage = https://www.sasview.org;
    description = "Fitting and data analysis for small angle scattering data";
    maintainers = with lib.maintainers; [ rprospero ];
    license = lib.licenses.bsd3;
  };
}
