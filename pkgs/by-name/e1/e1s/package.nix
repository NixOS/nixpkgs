{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "e1s";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bOG6txoreiP/buYO3rvcxhL1yAxlECkbwf9FqvWLz9k=";
  };

  vendorHash = "sha256-vVUuoAsoxVKDGxLOQBjOx56IiPWBbtYBJbJNq+kPV7A=";

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
