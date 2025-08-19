{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "bagels";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnhancedJax";
    repo = "bagels";
    tag = version;
    hash = "sha256-LlEQ0by6Si37e8FvC4agjLy8eanizSA1iq44BaQ8D5o=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  pythonRelaxDeps = true;

  dependencies = with python3Packages; [
    aiohappyeyeballs
    aiohttp-jinja2
    aiohttp
    aiosignal
    annotated-types
    attrs
    blinker
    click-default-group
    click
    frozenlist
    idna
    itsdangerous
    linkify-it-py
    markdown-it-py
    markupsafe
    mdit-py-plugins
    mdurl
    msgpack
    multidict
    numpy
    packaging
    platformdirs
    plotext
    propcache
    pydantic-core
    pydantic
    pygments
    python-dateutil
    pyyaml
    requests
    rich
    sqlalchemy
    textual
    tomli
    typing-extensions
    uc-micro-py
    werkzeug
    xdg-base-dirs
    yarl
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    freezegun
    pytestCheckHook
  ]);

  disabledTests = [
    # AssertionError: assert 1 == 0
    "test_delete_category"

    # AttributeError: 'NoneType' object has no attribute 'defaults'
    "test_basic_balance_calculation"
    "test_combined_balance_calculation"
    "test_get_days_in_period"
    "test_get_period_average"
    "test_get_period_figures"
    "test_get_start_end_of_period"
    "test_get_start_end_of_week"
    "test_split_balance_calculation"
    "test_transfer_balance_calculation"
  ];

  meta = {
    homepage = "https://github.com/EnhancedJax/Bagels";
    description = "Powerful expense tracker that lives in your terminal";
    longDescription = ''
      Bagels expense tracker is a TUI application where you can track and analyse your money flow, with convenience oriented features and a complete interface.
    '';
    changelog = "https://github.com/EnhancedJax/Bagels/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      loc
    ];
    mainProgram = "bagels";
  };
}
