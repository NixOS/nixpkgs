{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  crossplane-cli,
}:

buildGoModule (finalAttrs: {
  pname = "crossplane-cli";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "crossplane";
    repo = "crossplane";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SRqZKr/MTdfDwN5/mqWT5AcQAjNiCcbLyuTJCOcruzE=";
  };

  vendorHash = "sha256-vilm41nN7Qhyu9LfVk6Me9hA3YAipLYGjhSU/JZhfEM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crossplane/crossplane/v2/internal/version.version=v${finalAttrs.version}"
  ];

  subPackages = [ "cmd/crank" ];

  postInstall = ''
    mv $out/bin/crank $out/bin/crossplane
  '';

  passthru.tests.version = testers.testVersion {
    package = crossplane-cli;
    command = "crossplane version --client || true";
    version = "v${finalAttrs.version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.crossplane.io/";
    changelog = "https://github.com/crossplane/crossplane/releases/tag/v${finalAttrs.version}";
    description = "Utility to make using Crossplane easier";
    mainProgram = "crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ selfuryon ];
  };
})
