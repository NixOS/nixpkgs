{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "glance";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = "glance";
    rev = "v${version}";
    hash = "sha256-kQ4XVO6sotsIjIhkECn6FYik3ITYOZcDKyzk3I8JvkU=";
  };

  vendorHash = "sha256-lURRHlZoxbuW1SXxrxy2BkMndcEllGFmVCB4pXBad8Q=";

  excludedPackages = [ "scripts/build-and-ship" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      service = nixosTests.glance;
    };
  };

  meta = {
    homepage = "https://github.com/glanceapp/glance";
    changelog = "https://github.com/glanceapp/glance/releases/tag/v${version}";
    description = "Self-hosted dashboard that puts all your feeds in one place";
    mainProgram = "glance";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dvn0 ];
  };
}
