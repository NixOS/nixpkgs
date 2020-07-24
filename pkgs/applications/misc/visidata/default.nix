{ buildPythonApplication
, lib
, fetchFromGitHub
, dateutil
, pyyaml
, openpyxl
, xlrd
, h5py
, fonttools
, lxml
, pandas
, pyshp
, setuptools
}:
buildPythonApplication rec {
  pname = "visidata";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "19gs8i6chrrwibz706gib5sixx1cjgfzh7v011kp3izcrn524mc0";
  };

  propagatedBuildInputs = [
    dateutil
    pyyaml
    openpyxl
    xlrd
    h5py
    fonttools
    lxml
    pandas
    pyshp
    setuptools
  ];

  doCheck = false;

  meta = {
    inherit version;
    description = "Interactive terminal multitool for tabular data";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.raskin ];
    platforms = with lib.platforms; linux ++ darwin;
    homepage = "http://visidata.org/";
  };
}
