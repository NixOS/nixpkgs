{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "flux-build";
  version = "3.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DoodleScheduling";
    repo = "flux-build";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v5QjMgy9v0NAhGiqrYAHsxF1fWD5j9O0f1LUpIhe/is=";
  };

  vendorHash = "sha256-NNJYAqkwW/tpiG5tuu6Q4gwGQ7KF7pSXCSXsW/xd4QM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Build and test kustomize overlays with Flux HelmRelease templating";
    homepage = "https://github.com/DoodleScheduling/flux-build";
    license = lib.licenses.asl20;
    changelog = "https://github.com/DoodleScheduling/flux-build/releases/tag/v${finalAttrs.version}";
    mainProgram = "flux-build";
    maintainers = with lib.maintainers; [ MNThomson ];
    platforms = lib.platforms.unix;
  };
})
