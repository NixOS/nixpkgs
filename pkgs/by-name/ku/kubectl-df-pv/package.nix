{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-df-pv";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "yashbhutwala";
    repo = "kubectl-df-pv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-avHWyrTQpk4683JoU90i2H5pnzkZ5IoJ6r6TtXUhxvI=";
  };

  vendorHash = "sha256-Xz8ePhvo0yikpIf9b/7DjZHYWynwNFoL0juohyflZEg=";

  meta = {
    description = "df-like utility for persistent volumes on Kubernetes";
    mainProgram = "df-pv";
    homepage = "https://github.com/yashbhutwala/kubectl-df-pv";
    changelog = "https://github.com/yashbhutwala/kubectl-df-pv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jemand771 ];
  };
})
