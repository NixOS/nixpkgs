{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "baddns";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "baddns";
    tag = finalAttrs.version;
    hash = "sha256-k+DR7g0XllGzMBqKZ7vnxcPKH+QBkt9Irzd7mSVhWfg=";
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
    yara-python
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
    "test_cname_dnsnxdomain"
    "test_cname_http_bigcartel"
    "test_cname_nxdomain"
    "test_cname_probe_ip_prefers_ipv4"
    "test_cname_whois"
    "test_custom_signatures_dir"
    "test_debug_mode"
    "test_default_resolver"
    "test_delegation_rotating_dkim_selector_not_reported"
    "test_dmarc"
    "test_min_confidence"
    "test_min_severity"
    "test_modules_customnameservers"
    "test_mtasts"
    "test_ns_cname_chain_follow"
    "test_ns_nameserver_domain_unregistered[mock_dispatch_whois0]"
    "test_ns_nosoa"
    "test_ns_partial_lame"
    "test_ns_signature_confidence_override"
    "test_nsec"
    "test_references"
    "test_silent_mode"
    "test_spf"
    "test_txt_with_cname_findings"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool to check subdomains for subdomain takeovers and other DNS issues";
    homepage = "https://github.com/blacklanternsecurity/baddns/";
    changelog = "https://github.com/blacklanternsecurity/baddns/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "baddns";
  };
})
