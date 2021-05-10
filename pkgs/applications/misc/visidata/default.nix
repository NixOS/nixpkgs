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
  version = "2.4";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "0mvf2603d9b0s6rh7sl7mg4ipbh0nk05xgh1078mwvx31qjsmq1i";
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
