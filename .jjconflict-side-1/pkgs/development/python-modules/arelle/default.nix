{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  certifi,
  filelock,
  isodate,
  lxml,
  numpy,
  openpyxl,
  pyparsing,
  python-dateutil,
  regex,

  gui ? true,
  tkinter,

  pycryptodome,
  pg8000,
  pymysql,
  pyodbc,
  rdflib,
  holidays,
  pytz,
  tinycss2,
  graphviz,
  cheroot,
  cherrypy,
  tornado,

  sphinxHook,
  sphinx-autodoc2,
  myst-parser,
  sphinx-copybutton,
  furo,

  pytestCheckHook,
  boto3,
}:

buildPythonPackage rec {
  pname = "arelle${lib.optionalString (!gui) "-headless"}";
  version = "2.30.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    rev = "refs/tags/${version}";
    hash = "sha256-xzTrFie97HDIqPZ4nzCh+0p/w0bTK12cS0FSsuIi7tY=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
        'requires = ["setuptools~=73.0", "wheel~=0.44", "setuptools_scm[toml]~=8.1"]' \
        'requires = ["setuptools", "wheel", "setuptools_scm[toml]"]'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    certifi
    filelock
    isodate
    lxml
    numpy
    openpyxl
    pyparsing
    python-dateutil
    regex
  ] ++ lib.optionals gui [ tkinter ];

  optional-dependencies = {
    crypto = [ pycryptodome ];
    db = [
      pg8000
      pymysql
      pyodbc
      rdflib
    ];
    efm = [
      holidays
      pytz
    ];
    esef = [ tinycss2 ];
    objectmaker = [ graphviz ];
    webserver = [
      cheroot
      cherrypy
      tornado
    ];
  };

  nativeBuildInputs = [
    # deps for docs
    sphinxHook
    sphinx-autodoc2
    myst-parser
    sphinx-copybutton
    furo
  ];

  # the arelleGUI executable doesn't work when the gui option is false
  postInstall = lib.optionalString (!gui) ''
    find $out/bin -name "*arelleGUI*" -delete
  '';

  nativeCheckInputs = [
    pytestCheckHook
    boto3
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths =
    [
      "tests/integration_tests"
    ]
    ++ lib.optionals (!gui) [
      # these tests import tkinter
      "tests/unit_tests/arelle/test_updater.py"
      "tests/unit_tests/arelle/test_import.py"
    ];

  meta = {
    description = "Open source XBRL platform";
    longDescription = ''
      An open source facility for XBRL, the eXtensible Business Reporting
      Language supporting various standards, exposed through a Python or
      REST API ${lib.optionalString gui " and a graphical user interface"}.
    '';
    mainProgram = "arelle";
    homepage = "http://arelle.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tomasajt
      roberth
    ];
  };
}
