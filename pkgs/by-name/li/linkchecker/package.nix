{
  python3Packages,
  lib,
  fetchFromGitHub,
  gettext,
  pdfSupport ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linkchecker";
    repo = "linkchecker";
    tag = "v${version}";
    hash = "sha256-CzDShtqcGO2TP5qNVf2zkI3Yyh80I+pSVIFzmi3AaGQ=";
  };

  nativeBuildInputs = [ gettext ];

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
    polib # translations
  ];

  dependencies =
    with python3Packages;
    [
      argcomplete
      beautifulsoup4
      dnspython
      requests
    ]
    ++ lib.optional pdfSupport pdfminer-six;

  nativeCheckInputs = with python3Packages; [
    pyopenssl
    parameterized
    pytestCheckHook
    pyftpdlib
  ];

  # Needed for tests to be able to create a ~/.local/share/linkchecker/plugins directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    "test_timeit2" # flakey, and depends sleep being precise to the milisecond
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Check websites for broken links";
    mainProgram = "linkchecker";
    homepage = "https://linkcheck.github.io/linkchecker/";
    changelog = "https://github.com/linkchecker/linkchecker/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      tweber
    ];
  };
}
