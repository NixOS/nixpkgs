{ stdenv
, lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
  # python requirements
, beautifulsoup4
, boto3
, faker
, fonttools
, h5py
, importlib-metadata
, lxml
, matplotlib
, numpy
, odfpy
, openpyxl
, pandas
, pdfminer-six
, praw
, psutil
, psycopg2
, pyarrow
, pyshp
, pypng
, python-dateutil
, pyyaml
, requests
, seaborn
, setuptools
, sh
, tabulate
, urllib3
, vobject
, wcwidth
, xlrd
, xlwt
, zstandard
, zulip
# other
, git
, withPcap ? true, dpkt, dnslib
, withXclip ? stdenv.isLinux, xclip
, testers
, visidata
}:
buildPythonApplication rec {
  pname = "visidata";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    hash = "sha256-gplrkrFTIP6TLvk1YazD5roDzsPvDtOXLlTOmTio52s=";
  };

  patches = [
    # Drop when next release is out
    (fetchpatch {
      name = "drop-support-for-python-37.patch";
      url = "https://github.com/saulpw/visidata/commit/738bb8b43814c14b1b8a1f1f60397c1520c5ef4a.patch";
      hash = "sha256-5jDAzKMuW3s7BCGpWyLcS4Lw8GUbjNxVhF5mUKbR1YY=";
    })
    (fetchpatch {
      name = "update-tests-for-python-312.patch";
      url = "https://github.com/saulpw/visidata/commit/627f6f126cdd49bcdda0bbc16fab42eb5bd42103.patch";
      hash = "sha256-3FHgjLrzMHObEheJoRY8VlnDUtDZ68FqCqAyhP7333E=";
    })
  ];

  propagatedBuildInputs = [
    # from visidata/requirements.txt
    # packages not (yet) present in nixpkgs are commented
    python-dateutil
    pandas
    requests
    lxml
    openpyxl
    xlrd
    xlwt
    h5py
    psycopg2
    boto3
    pyshp
    #mapbox-vector-tile
    pypng
    #pyconll
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
    urllib3
    pyarrow
    seaborn
    matplotlib
    sh
    psutil
    numpy

    #requests_cache
    beautifulsoup4

    faker
    praw
    zulip
    #pyairtable

    setuptools
    importlib-metadata
  ] ++ lib.optionals withPcap [ dpkt dnslib ]
  ++ lib.optional withXclip xclip;

  nativeCheckInputs = [
    git
  ];

  # check phase uses the output bin, which is not possible when cross-compiling
  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    # disable some tests which require access to the network
    rm -f tests/load-http.vd            # http
    rm -f tests/graph-cursor-nosave.vd  # http
    rm -f tests/messenger-nosave.vd     # dns

    # tests to disable because we don't have a package to load such files
    rm -f tests/load-conllu.vdj         # no 'pyconll'
    rm -f tests/load-sav.vd             # no 'savReaderWriter'

    # tests use git to compare outputs to references
    git init -b "test-reference"
    git config user.name "nobody"
    git config user.email "no@where"
    git add .
    git commit -m "test reference"

    substituteInPlace dev/test.sh --replace "bin/vd" "$out/bin/vd"
    bash dev/test.sh
    runHook postCheck
  '';
  postInstall = ''
    python dev/zsh-completion.py
    install -Dm644 _visidata -t $out/share/zsh/site-functions
  '';

  pythonImportsCheck = ["visidata"];

  passthru.tests.version = testers.testVersion {
    package = visidata;
    version = "v${version}";
  };

  meta = {
    description = "Interactive terminal multitool for tabular data";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ raskin markus1189 ];
    homepage = "https://visidata.org/";
    changelog = "https://github.com/saulpw/visidata/blob/v${version}/CHANGELOG.md";
  };
}
