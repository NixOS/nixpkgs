{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "maigret";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = "maigret";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y5b7t4ji72o1PXoqEQ0vNHqE1vwdkB/3gtsCj5GZ4Xg=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "future-annotations"
    "future"
    "six"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies =
    with python3.pkgs;
    [
      aiodns
      aiohttp
      aiohttp-socks
      alive-progress
      arabic-reshaper
      asgiref
      async-timeout
      attrs
      beautifulsoup4
      certifi
      chardet
      cloudscraper
      colorama
      flask
      html5lib
      idna
      jinja2
      lxml
      markupsafe
      mock
      multidict
      networkx
      platformdirs
      pycountry
      pypdf2
      pysocks
      python-bidi
      pyvis
      requests
      requests-futures
      socid-extractor
      soupsieve
      stem
      torrequest
      tqdm
      typing-extensions
      webencodings
      xhtml2pdf
      xmind
      yarl
    ]
    ++ flask.optional-dependencies.async;

  nativeCheckInputs = with python3.pkgs; [
    pytest-httpserver
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlags = [
    # DeprecationWarning: There is no current event loop
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # Tests require network access
    "test_extract_ids_from_page"
    "test_import_aiohttp_cookies"
    "test_maigret_results"
    "test_pdf_report"
    "test_self_check_db_negative_enabled"
    "test_self_check_db_positive_enable"
    "test_detect_known_engine"
    "test_check_features_manually_success"
    "test_dialog_adds_site_positive"
    "test_dialog_replace_site"
    "test_dialog_adds_site_negative"
    #
    "test_self_check_db"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AsyncioProgressbarExecutor is slower on darwin than it should be,
    # Upstream issue: https://github.com/soxoj/maigret/issues/679
    "test_asyncio_progressbar_executor"
  ];

  pythonImportsCheck = [ "maigret" ];

  meta = {
    description = "Tool to collect details about an username";
    homepage = "https://maigret.readthedocs.io";
    changelog = "https://github.com/soxoj/maigret/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      thtrf
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
