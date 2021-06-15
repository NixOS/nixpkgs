{ buildPythonApplication
, lib
, fetchFromGitHub
, dateutil
, pandas
, requests
, lxml
, openpyxl
, xlrd
, h5py
, psycopg2
, pyshp
, fonttools
, pyyaml
, pdfminer
, vobject
, tabulate
, wcwidth
, zstandard
, setuptools
, withPcap ? true, dpkt, dnslib
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
    # from visidata/requirements.txt
    # packages not (yet) present in nixpkgs are commented
    dateutil
    pandas
    requests
    lxml
    openpyxl
    xlrd
    h5py
    psycopg2
    pyshp
    #mapbox-vector-tile
    #pypng
    fonttools
    #sas7bdat
    #xport
    #savReaderWriter
    pyyaml
    #namestand
    #datapackage
    pdfminer
    #tabula
    vobject
    tabulate
    wcwidth
    zstandard
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
