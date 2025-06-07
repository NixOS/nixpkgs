{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "crowdsec-firewall-bouncer";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "crowdsecurity";
    repo = "cs-firewall-bouncer";
    tag = "v${version}";
    hash = "sha256-4fxxAW2sXGNxjsc75fd499ciuN8tjGqlpRIaHYUXwQ0=";
  };

  vendorHash = "sha256-Bhp6Z2UlCJ32vdc3uINCGleZFP2WeUn/XK+Q29szUzQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${placeholder "out"}/bin/cs-firewall-bouncer";
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://crowdsec.net/";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.tag}";
    description = "Crowdsec bouncer written in golang for firewalls";
    longDescription = ''
      CrowdSec Remediation Component written in golang for firewalls.

      crowdsec-firewall-bouncer will fetch new and old decisions from a
      CrowdSec API and add them to a blocklist used by supported firewalls.
    '';
    license = licenses.mit;
    mainProgram = "cs-firewall-bouncer";
    maintainers = with maintainers; [
      tornax
    ];
  };
}
