{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dmarc-metrics-exporter";
  version = "1.3.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jgosmann";
    repo = "dmarc-metrics-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mp4gQi+cLAoVKVSmGbgruPYPVJV6vxwzVOnx+CZhxS8=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies =
    with python3Packages;
    [
      bite-parser
      prometheus-client
      pydantic
      structlog
      uvicorn
      xsdata
    ]
    ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = with python3Packages; [
    aiohttp
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky tests
    "test_build_info"
    "test_prometheus_exporter"
  ];

  disabledTestPaths = [
    # require networking
    "dmarc_metrics_exporter/tests/test_e2e.py"
    "dmarc_metrics_exporter/tests/test_imap_client.py"
    "dmarc_metrics_exporter/tests/test_imap_queue.py"
  ];

  pythonImportsCheck = [ "dmarc_metrics_exporter" ];

  meta = {
    description = "Export Prometheus metrics from DMARC reports";
    mainProgram = "dmarc-metrics-exporter";
    homepage = "https://github.com/jgosmann/dmarc-metrics-exporter";
    changelog = "https://github.com/jgosmann/dmarc-metrics-exporter/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
})
