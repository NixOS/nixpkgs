{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "e1s";
  version = "1.0.53";

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cy/aZVO6xM1oCeyT6x1O+otbUZ5lS90fl3iZzkf02QM=";
  };

  vendorHash = "sha256-8z2RVT2W8TLXdZBAmi/2fu63pijVgzqSvF9xpGexlQ0=";

  meta = {
    description = "Easily Manage AWS ECS Resources in Terminal";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/keidarcy/e1s/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "e1s";
    maintainers = with lib.maintainers; [
      zelkourban
      carlossless
    ];
  };
})
