{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
  cdxgen,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "dep-scan";
  version = "6.0.0b5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "owasp-dep-scan";
    repo = "dep-scan";
    tag = "v${version}";
    hash = "sha256-D+ILgWifIV27CG4aJUHeI6F7ASomS0iyAG0beIIzJNk=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    appthreat-vulnerability-db
    custom-json-diff
    cvss
    defusedxml
    ds-analysis-lib
    ds-reporting-lib
    ds-server-lib
    ds-xbom-lib
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

  pythonImportsCheck = [ "depscan" ];

  disabledTests = [
    # Test is not present
    "test_query_metadata2"
  ];

  # depscan --src shiftleft/scan-slim -o containertests -t docker
  #
  # WARNING [2025-07-28 20:17:35,654] cdxgen command not found. Please install using npm install @cyclonedx/cdxgen or set PATH variable
  # WARNING [2025-07-28 20:17:35,654] /nix/store/56bxjw4rgdqa82f61w70z92qq6b14ass-dep-scan-5.5.0/lib/python3.13/site-packages/depscan/lib/local_bin/cdxgen command not found. Please install using npm install @cyclonedx/cdxgen or set PATH variable
  # INFO [2025-07-28 20:17:35,654] Generating Software Bill-of-Materials for container image shiftleft/scan-slim. This might take a few mins ...
  # WARNING [2025-07-28 20:17:35,654] Unable to locate cdxgen command.
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        cdxgen
      ]
    }"
  ];

  passthru.tests = { inherit (nixosTests) dep-scan; };

  meta = {
    description = "Security and risk audit tool based on known vulnerabilities, advisories, and license limitations for project dependencies";
    homepage = "https://github.com/owasp-dep-scan/dep-scan";
    changelog = "https://github.com/owasp-dep-scan/dep-scan/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    teams = [ lib.teams.ngi ];
    mainProgram = "dep-scan";
  };
}
