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
    # Huggingface has a habit of removing their pinned commit dataset urls
    # so an update script exists to keep these models up to date
    updateScript = ./update.sh;
    vdb = {
      index = fetchurl {
        url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/207ab805b2656679bb649b2ff6aef4fa875fade5/app-2y/data.index.vdb6";
        hash = "sha256-PVWyNVV+vHWELLA0QxI47fhCbrlvXJXM2llL14vMtg4=";
      };
      data = fetchurl {
        url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/207ab805b2656679bb649b2ff6aef4fa875fade5/app-2y/data.vdb6";
        hash = "sha256-Q/+xYfq5BtSH+c0RMwUDBu10kcmjnDeKD3kH5oVUxzM=";
      };
      meta = fetchurl {
        url = "https://huggingface.co/datasets/AppThreat/vdb/resolve/207ab805b2656679bb649b2ff6aef4fa875fade5/app-2y/vdb.meta";
        hash = "sha256-l8BJHoetvxV2YJQLPo9n/3AB01XvSKgj5HbQc2hSqxY=";
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
