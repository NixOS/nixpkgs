{
  lib,
  python3Packages,
  fetchurl,
}:

python3Packages.buildPythonApplication rec {
  pname = "cbmc-viewer";
  version = "3.11.1";
  format = "wheel";

  src = fetchurl {
    url = "https://github.com/model-checking/${pname}/releases/download/viewer-${version}/cbmc_viewer-${version}-py3-none-any.whl";
    hash = "sha256-mT2JPUQ+t3r/MXUTH+OO0dpd/9N85HTuRljSoAm+FgA=";
  };

  propagatedBuildInputs = with python3Packages; [
    setuptools
    jinja2
    voluptuous
  ];

  meta = {
    description = "Produces browsable summary of CBMC model checker output";
    homepage = "https://github.com/model-checking/cbmc-viewer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jacg ];
    mainProgram = "cbmc-viewer";
  };
}
