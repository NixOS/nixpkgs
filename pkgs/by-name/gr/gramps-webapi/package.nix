{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gramps-webapi";
  version = "3.24.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps-web-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fw+wfaRYG85JbFeerzPxvg5FXHdVS9chj/dqbmfA0M4=";
  };

  pythonRelaxDeps = [
    "pillow"
    "pygobject"
    "pywebpush"
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies =
    with python3Packages;
    [
      alembic
      authlib
      bleach
      boto3
      celery
      click
      cryptography
      ffmpeg-python
      flask
      flask-caching
      flask-compress
      flask-cors
      flask-jwt-extended
      flask-limiter
      flask-smorest
      flask-sqlalchemy
      gramps
      gramps-gedcom7
      gramps-object-query-language
      gramps-ql
      httpx
      jsonschema
      limits
      marshmallow
      object-ql
      orjson
      pdf2image
      pillow
      py-vapid
      pygobject3
      pytesseract
      pywebpush
      requests
      sifts
      sqlalchemy
      typing-extensions
      unidecode
      waitress
      webargs
      yclade
    ]
    ++ bleach.optional-dependencies.css
    ++ celery.optional-dependencies.redis;

  optional-dependencies = {
    ai =
      with python3Packages;
      [
        pydantic-ai-slim
        sentence-transformers
        accelerate
      ]
      ++ pydantic-ai-slim.optional-dependencies.openai;
    face = with python3Packages; [
      opencv-python-headless
    ];
    sentry = with python3Packages; [ sentry-sdk ] ++ sentry-sdk.optional-dependencies.flask;
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
      moto
      writableTmpDirAsHomeHook
    ]
    ++ moto.optional-dependencies.s3;

  disabledTestPaths = [
    # Slow and require every LLM provider SDK,
    # PyTorch and Internet access to download an embedding model
    "tests/test_llm_agent.py"
    "tests/test_llm_errors.py"
    "tests/test_llm_render.py"
    "tests/test_llm_tools.py"
    "tests/test_endpoints"
  ];

  pythonImportsCheck = [ "gramps_webapi" ];

  meta = {
    description = "RESTful web API for Gramps, the backend of Gramps Web";
    homepage = "https://www.grampsweb.org/";
    changelog = "https://github.com/gramps-project/gramps-web-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      anthonyroussel
      jk
    ];
  };
})
