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
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "1gkvnywjg0n3n7d855ivclsj3d8mzihhkgv9a18srcszkmyix903";
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
    homepage = "http://visidata.org/";
    changelog = "https://github.com/saulpw/visidata/blob/v${version}/CHANGELOG.md";
  };
}
