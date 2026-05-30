{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "crowdsec-blocklist-import";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "wolffcatskyy";
    repo = "crowdsec-blocklist-import";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KuPohvN2kN9f0N35sANwK/p2oGhim0hOghk/UZcvdsA=";
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

  __structuredAttrs = true;

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

      Ideal for home labs and personal projects.

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
