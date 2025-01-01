{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pubs";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "refs/tags/v${version}";
    hash = "sha256-U/9MLqfXrzYVGttFSafw4pYDy26WgdsJMCxciZzO1pw=";
  };

  patches = [
    # https://github.com/pubs/pubs/pull/278
    (fetchpatch {
      url = "https://github.com/pubs/pubs/commit/9623d2c3ca8ff6d2bb7f6c8d8624f9a174d831bc.patch";
      hash = "sha256-6qoufKPv3k6C9BQTZ2/175Nk7zWPh89vG+zebx6ZFOk=";
    })
    # https://github.com/pubs/pubs/pull/279
    (fetchpatch {
      url = "https://github.com/pubs/pubs/commit/05e214eb406447196c77c8aa3e4658f70e505f23.patch";
      hash = "sha256-UBkKiYaG6y6z8lsRpdcsaGsoklv6qj07KWdfkQcVl2g=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    argcomplete
    beautifulsoup4
    bibtexparser
    configobj
    feedparser
    python-dateutil
    pyyaml
    requests
    six
  ];

  nativeCheckInputs = with python3.pkgs; [
    ddt
    mock
    pyfakefs
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disabling git tests because they expect git to be preconfigured
    # with the user's details. See
    # https://github.com/NixOS/nixpkgs/issues/94663
    "tests/test_git.py"
  ];

  disabledTests = [
    # https://github.com/pubs/pubs/issues/276
    "test_readme"
    # AssertionError: Lists differ: ['Ini[112 chars]d to...
    "test_add_non_standard"
  ];

  pythonImportsCheck = [
    "pubs"
  ];

  meta = with lib; {
    description = "Command-line bibliography manager";
    mainProgram = "pubs";
    homepage = "https://github.com/pubs/pubs";
    changelog = "https://github.com/pubs/pubs/blob/v${version}/changelog.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      gebner
      dotlambda
    ];
  };
}
