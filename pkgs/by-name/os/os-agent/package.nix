{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "os-agent";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "os-agent";
    tag = finalAttrs.version;
    hash = "sha256-jO7TE4lBqyxUYcy3ZsZAFO98orGJ6hTM97+G/ueawNg=";
  };

  vendorHash = "sha256-WC251fHO3XRICP7q7RdHCTnf8WfqNKnueCp36uEtrIg=";

  ldFlags = [
    "-X main.version="
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Daemon allowing to control OS features through D-Bus";
    homepage = "https://github.com/home-assistant/os-agent";
    changelog = "https://github.com/home-assistant/os-agent/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "os-agent";
  };
})
