{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "bagels";
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnhancedJax";
    repo = "bagels";
    tag = version;
    hash = "sha256-dmBu0HSRGs4LmJY2PHNlRf0RdodmN+ZM0brwuiNmPyU=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  pythonRelaxDeps = [
    "aiohappyeyeballs"
    "aiohttp"
    "aiosignal"
    "attrs"
    "blinker"
    "click"
    "multidict"
    "platformdirs"
    "propcache"
    "pydantic-core"
    "pydantic"
    "pygments"
    "requests"
    "rich"
    "sqlalchemy"
    "textual"
    "typing-extensions"
    "werkzeug"
    "yarl"
  ];

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

  meta = {
    homepage = "https://github.com/EnhancedJax/Bagels";
    description = "Powerful expense tracker that lives in your terminal.";
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
