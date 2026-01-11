{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-do";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "gh-do";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TzdaQ/E9D3gB1Q84SCRetLoA95c/BjJlgfZGbntjCVU=";
  };

  vendorHash = "sha256-TPHDiMzJtXXRBFd8lacXeMC+AB1Gc1pMyJPJeVLCkKo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Do and undo and notify with GitHub CLI";
    homepage = "https://github.com/k1LoW/gh-do";
    changelog = "https://github.com/k1LoW/gh-do/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "gh-do";
  };
})
