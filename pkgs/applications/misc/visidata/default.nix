{ buildPythonApplication, lib, fetchFromGitHub
, dateutil, pyyaml, openpyxl, xlrd, h5py, fonttools, lxml, pandas, pyshp
}:
buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "visidata";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "1d5sx1kfil1vjkynaac5sjsnn9azxxw834gwbh9plzd5fwxg4dz2";
  };

  propagatedBuildInputs = [dateutil pyyaml openpyxl xlrd h5py fonttools
    lxml pandas pyshp ];

  doCheck = false;

  meta = {
    inherit version;
    description = "Interactive terminal multitool for tabular data";
    license = lib.licenses.gpl3 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "http://visidata.org/";
  };
}
