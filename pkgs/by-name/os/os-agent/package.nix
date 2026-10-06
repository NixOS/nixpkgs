{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "os-agent";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "os-agent";
    tag = finalAttrs.version;
    hash = "sha256-jxG0YKw/pPrM+VEWdnrJ8jPTc8rfFKm5/Op6i3KugzA=";
  };

  vendorHash = "sha256-HMf6K0TZzi3qXibPdeYLzrGdxPHrSxft+fCDzNChu/4=";

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
