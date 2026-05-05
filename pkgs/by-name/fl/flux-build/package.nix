{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "flux-build";
  version = "3.0.10";

  src = fetchFromGitHub {
    owner = "DoodleScheduling";
    repo = "flux-build";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ToQVm69XqJgRahunUXjNnIiieqSV8TzgFdtFJktz5/g=";
  };

  vendorHash = "sha256-kVi/VVVPTblDvCjvnsKxfqYELBahHmzTlW74ktdZC7k=";

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
