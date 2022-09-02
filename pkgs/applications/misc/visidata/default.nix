{ stdenv
, lib
, buildPythonApplication
, fetchFromGitHub
, python-dateutil
, pandas
, requests
, lxml
, openpyxl
, xlrd
, h5py
, odfpy
, psycopg2
, pyshp
, fonttools
, pyyaml
, pdfminer-six
, vobject
, tabulate
, wcwidth
, zstandard
, setuptools
, git
, withPcap ? true, dpkt, dnslib
, withXclip ? stdenv.isLinux, xclip
}:
buildPythonApplication rec {
  pname = "visidata";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    hash = "sha256-PKj+imTSAGMpF1tkN0WmE3l/4FmWkm/ktIDzF2ku48s=";
  };

  propagatedBuildInputs = [
    # from visidata/requirements.txt
    # packages not (yet) present in nixpkgs are commented
    python-dateutil
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
    pdfminer-six
    #tabula
    vobject
    tabulate
    wcwidth
    zstandard
    odfpy
    setuptools
  ] ++ lib.optionals withPcap [ dpkt dnslib ]
  ++ lib.optional withXclip xclip;

  checkInputs = [
    git
  ];

  # check phase uses the output bin, which is not possible when cross-compiling
  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  checkPhase = ''
    # disable some tests which require access to the network
    rm tests/load-http.vd            # http
    rm tests/graph-cursor-nosave.vd  # http
    rm tests/messenger-nosave.vd     # dns

    # tests use git to compare outputs to references
    git init -b "test-reference"
    git config user.name "nobody"; git config user.email "no@where"
    git add .; git commit -m "test reference"

    substituteInPlace dev/test.sh --replace "bin/vd" "$out/bin/vd"
    bash dev/test.sh
  '';

  meta = {
    description = "Interactive terminal multitool for tabular data";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ raskin markus1189 ];
    homepage = "http://visidata.org/";
    changelog = "https://github.com/saulpw/visidata/blob/v${version}/CHANGELOG.md";
  };
}
