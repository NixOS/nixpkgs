{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-do";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "gh-do";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V88ijuj2s2vxqDFoQkL9CSllCIqUsYcSNBth3MQUhYw=";
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
