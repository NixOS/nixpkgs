{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  writableTmpDirAsHomeHook,
  cdxgen,
  jq,
  runCommand,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dep-scan";
  version = "6.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "owasp-dep-scan";
    repo = "dep-scan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sStziMmhZz5yytaU5rUDTcdQCEsXL19FI/gpSIVxI0o=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [
    "defusedxml"
  ];

  dependencies = with python3Packages; [
    appthreat-vulnerability-db
    custom-json-diff
    cvss
    defusedxml
    ds-analysis-lib
    ds-reporting-lib
    ds-server-lib
    ds-xbom-lib
    httpx
    jinja2
    oras
    packageurl-python
    pdfkit
    pygithub
    pyyaml
    quart
    rich
    toml
  ];

  nativeCheckInputs = with python3Packages; [
    httpretty
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  pythonImportsCheck = [ "depscan" ];

  disabledTests = [
    # Test is not present
    "test_query_metadata2"
    # AssertionError
    "test_validate_remote_url_accepts_plain_public_url"
  ];

  # depscan --src shiftleft/scan-slim -o containertests -t docker
  #
  # WARNING [2025-07-28 20:17:35,654] cdxgen command not found. Please install using npm install @cyclonedx/cdxgen or set PATH variable
  # WARNING [2025-07-28 20:17:35,654] /nix/store/56bxjw4rgdqa82f61w70z92qq6b14ass-dep-scan-5.5.0/lib/python3.13/site-packages/depscan/lib/local_bin/cdxgen command not found. Please install using npm install @cyclonedx/cdxgen or set PATH variable
  # INFO [2025-07-28 20:17:35,654] Generating Software Bill-of-Materials for container image shiftleft/scan-slim. This might take a few mins ...
  # WARNING [2025-07-28 20:17:35,654] Unable to locate cdxgen command.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      cdxgen
    ])
  ];

  passthru = {
    vdb = {
      index = fetchurl {
        url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/40609f230dd7c83178e054e0219c367b49a2c920/app-2y/data.index.vdb6";
        hash = "sha256-UyE0xiLT0T4ygBdEvDi4VQW/vxwalN6YV9EJ9RoLYy4=";
      };
      data = fetchurl {
        url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/40609f230dd7c83178e054e0219c367b49a2c920/app-2y/data.vdb6";
        hash = "sha256-k5QIowFD8H/hwaRz1p8RXlFEIrKjnFUtxtZTfD67B+U=";
      };
      meta = fetchurl {
        url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/40609f230dd7c83178e054e0219c367b49a2c920/app-2y/vdb.meta";
        hash = "sha256-eQB0dHlNw31sKsRcVUByhIfuIN35+m3VAcBHIfusNPY=";
      };
    };

    tests.scan =
      runCommand "dep-scan-test"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            jq
          ];
        }
        ''
          mkdir -p vdb
          cp ${finalAttrs.passthru.vdb.index} vdb/data.index.vdb6
          cp ${finalAttrs.passthru.vdb.data} vdb/data.vdb6
          cp ${finalAttrs.passthru.vdb.meta} vdb/vdb.meta

          export VDB_HOME=$(pwd)/vdb
          export VDB_AGE_HOURS=999999
          export HOME=$(pwd)/home
          mkdir -p "$HOME" reports

          depscan --src ${finalAttrs.src} --reports-dir reports
          jq . reports/*.json

          touch $out
        '';
  };

  meta = {
    description = "Security and risk audit tool based on known vulnerabilities, advisories, and license limitations for project dependencies";
    homepage = "https://github.com/owasp-dep-scan/dep-scan";
    changelog = "https://github.com/owasp-dep-scan/dep-scan/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    teams = [ lib.teams.ngi ];
    mainProgram = "depscan";
  };
})
