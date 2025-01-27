{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "os-agent";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "os-agent";
    tag = "${version}";
    hash = "sha256-euBoRlgYtQmuYyIxD3yxbvXc4Zcke2JXGOlBmY0mRZU=";
  };

  vendorHash = "sha256-zWvvQsEBtGX2qa6HoG2sYv8q5fi/wM0eDQa8jLjh4+A=";

  ldFlags = [
    "-X main.version="
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Daemon allowing to control OS features through D-Bus";
    homepage = "https://github.com/home-assistant/os-agent";
    changelog = "https://github.com/home-assistant/os-agent/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "os-agent";
  };
}
