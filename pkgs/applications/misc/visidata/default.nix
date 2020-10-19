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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "sha256-AkGU9p00y+psBS/fL2YLyQYRSMOp1aPs21E9bpN9z0M=";
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
