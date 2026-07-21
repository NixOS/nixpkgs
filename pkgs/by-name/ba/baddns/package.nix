{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "baddns";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "baddns";
    tag = finalAttrs.version;
    hash = "sha256-3SKR94/KBjTxk7swPKaIn2zzAjYMSEqqLALeCBjwMFg=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    colorama
    cloudcheck
    dnspython
    blastdns
    blasthttp
    httpx
    python-dateutil
    python-whois
    pyyaml
    setuptools
    tldextract
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pyfakefs
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "baddns" ];

  disabledTests = [
    # Tests require network access
    "test_cli_cname_http"
    "test_cli_cname_nxdomain"
    "test_cli_direct"
    "test_cli_validation_customnameservers_valid"
    "test_cname_http_bigcartel_match"
    "test_cname_whois_unregistered_baddata"
    "test_cname_whois_unregistered_match"
    "test_cname_whois_unregistered_missingdata"
    "test_custom_signatures_dir"
    "test_debug_mode"
    "test_default_resolver"
    "test_dmarc"
    "test_min_confidence_confirmed_excludes_high"
    "test_min_confidence_filters_findings"
    "test_min_severity_critical_excludes_medium"
    "test_min_severity_low_includes_medium"
    "test_modules_customnameservers"
    "test_references_cname_css"
    "test_references_cname_js"
    "test_silent_mode"
    "test_spf"
  ];

  meta = {
    description = "Tool to check subdomains for subdomain takeovers and other DNS issues";
    homepage = "https://github.com/blacklanternsecurity/baddns/";
    changelog = "https://github.com/blacklanternsecurity/baddns/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "baddns";
  };
})
