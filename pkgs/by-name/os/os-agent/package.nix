{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "os-agent";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "os-agent";
    tag = finalAttrs.version;
    hash = "sha256-Mi3anP+fqKTC+YS++MommXPg6IjCtSYfVL4nSPbws1U=";
  };

  vendorHash = "sha256-Uwy2R7nQyCC1K/2ShRRvmEURWztNGepGzM4KReBtGug=";

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
