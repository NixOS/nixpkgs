{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-skyline";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-skyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yc9NaWx1jV2YUpPz2u9irikkLw1cnManq+AXREvCfII=";
  };

  vendorHash = "sha256-fPXpgiCA9k8tYQ2leCb+XR34OGJZ6YWCFAxG9mTeXoI=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate a 3D model of your GitHub contribution history";
    homepage = "https://github.com/github/gh-skyline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
    mainProgram = "gh-skyline";
  };
})
