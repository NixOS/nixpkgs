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
, withPcap ? true, dpkt ? null, dnslib ? null
}:
buildPythonApplication rec {
  pname = "visidata";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "1psb3ycrb7k00b5blg9zr52bzdxs1mkdc7rpjn4m9kh09yfs3sx4";
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
  ] ++ lib.optionals withPcap [ dpkt dnslib ];

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
