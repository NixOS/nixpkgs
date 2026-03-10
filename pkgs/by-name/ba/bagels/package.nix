{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bagels";
  version = "0.3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnhancedJax";
    repo = "bagels";
    tag = finalAttrs.version;
    hash = "sha256-w7Q7yCKffya2SyuHUaTWOugkeyTZbL9JNj/Ir3tnafE=";
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
    "test_create_template"
    "test_create_multiple_templates"
    "test_delete_template"
    "test_get_adjacent_template"
    "test_get_all_templates"
    "test_get_days_in_period"
    "test_get_period_average"
    "test_get_period_figures"
    "test_get_start_end_of_period"
    "test_get_start_end_of_week"
    "test_get_template_by_id"
    "test_split_balance_calculation"
    "test_swap_template_order"
    "test_swap_template_order_edge_cases"
    "test_template_validation"
    "test_transfer_balance_calculation"
    "test_update_template"
  ];

  meta = {
    homepage = "https://github.com/EnhancedJax/Bagels";
    description = "Powerful expense tracker that lives in your terminal";
    longDescription = ''
      Bagels expense tracker is a TUI application where you can track and analyse your money flow, with convenience oriented features and a complete interface.
    '';
    changelog = "https://github.com/EnhancedJax/Bagels/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      loc
    ];
    mainProgram = "bagels";
  };
})
