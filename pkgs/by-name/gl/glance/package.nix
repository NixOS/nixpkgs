{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "glance";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = "glance";
    rev = "v${version}";
    hash = "sha256-0P1f7IDEPSlVHtrygIsD502lIHqLISsSAi9pqB/gFdA=";
  };

  vendorHash = "sha256-BLWaYiWcLX+/DW7Zzp6/Mtw5uVxIVtfubB895hrZ+08=";

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
