{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "crowdsec-firewall-bouncer";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "crowdsecurity";
    repo = "cs-firewall-bouncer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4fxxAW2sXGNxjsc75fd499ciuN8tjGqlpRIaHYUXwQ0=";
  };

  vendorHash = "sha256-Bhp6Z2UlCJ32vdc3uINCGleZFP2WeUn/XK+Q29szUzQ=";

  ldflags = [
    "-X github.com/crowdsecurity/go-cs-lib/version.Version=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${placeholder "out"}/bin/cs-firewall-bouncer";
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$" ];
    };
  };

  meta = {
    homepage = "https://crowdsec.net/";
    downloadPage = "https://github.com/crowdsecurity/cs-firewall-bouncer";
    changelog = "https://github.com/crowdsecurity/cs-firewall-bouncer/releases/tag/v${finalAttrs.version}";
    description = "Crowdsec bouncer written in golang for firewalls";
    longDescription = ''
      CrowdSec Remediation Component written in golang for firewalls.

      crowdsec-firewall-bouncer will fetch new and old decisions from a
      CrowdSec API and add them to a blocklist used by supported firewalls.
    '';
    license = lib.licenses.mit;
    mainProgram = "cs-firewall-bouncer";
    maintainers = with lib.maintainers; [
      tornax
      jk
    ];
  };
})
