{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "crowdsec-blocklist-import";
  version = "3.6.0-alpha.1";

  src = fetchFromGitHub {
    owner = "gaelj"; # "wolffcatskyy";
    repo = "crowdsec-blocklist-import";
    # tag = "v${finalAttrs.version}";
    rev = "fix-3.6.0";
    hash = "sha256-o6Pe8IizMK8lB2Q8Uk50tY8aUP2f8quZ/hZWnEbesj0=";
  };

  pyproject = true;

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    requests
    prometheus-client
    python-dotenv
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test_blocklist_import.py"
    "-v"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 blocklist_import.py $out/bin/crowdsec-blocklist-import
    install -Dm644 grafana-dashboard.json $out/share/grafana/dashboards/crowdsec-blocklist-import.json

    runHook postInstall
  '';

  meta = {
    description = "Import 60,000+ IPs from 30+ public threat feeds directly into CrowdSec";
    longDescription = ''
      CrowdSec Blocklist Import aggregates threat intelligence from 30+ public
      blocklists and imports them directly into CrowdSec with automatic deduplication.

      Features:
      - 30+ Free Blocklists: IPsum, Spamhaus, Firehol, Abuse.ch, Emerging Threats, and more
      - Smart Deduplication: Skips IPs already in CrowdSec (CAPI, Console lists, local detections)
      - Private IP Filtering: Automatically excludes RFC1918 and reserved ranges
      - Docker Ready: Run as a container with Docker socket access
      - Cron Friendly: Designed for daily runs with 24h decision expiration
      - Selective Sources: Enable/disable individual blocklists
      - Custom Blocklist URLs: Import your own threat feeds
      - Dry Run Mode: Preview imports without making changes
      - Per-Source Statistics: Summary table showing IP counts from each source

      Ideal for homelabs and personal projects.

      Consider CrowdSec Premium when:

      - Business/production environments needing SLA support
      - Concerns about false positives on VPN/proxy traffic
      - Need curated, lower-noise blocklists
      - Want the official 25k-100k+ threat feed with 5-minute updates
    '';
    homepage = "https://github.com/wolffcatskyy/crowdsec-blocklist-import";
    changelog = "https://github.com/wolffcatskyy/crowdsec-blocklist-import/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "crowdsec-blocklist-import";
    maintainers = with lib.maintainers; [
      gaelj
      tornax
    ];
    platforms = lib.platforms.linux;
  };
})
