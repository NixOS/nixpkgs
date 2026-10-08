{
  fetchFromGitHub,
  buildGoModule,
  lib,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "lstk";
  version = "0.22.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "lstk";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-SavoRL6MP4owejL+BX1VgsBMLsuNdCw3rj2n+Il/+IU=";
  };

  vendorHash = "sha256-AvNFx3kMin6r788PCRdZ7qU3dUpJ/OILoY6hgvIXz+w=";

  excludedPackages = "test/integration";

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line interface for LocalStack";
    mainProgram = "lstk";
    homepage = "https://github.com/localstack/lstk";
    changelog = "https://github.com/localstack/lstk/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      lstk is a command-line interface for LocalStack built in Go with a modern
      terminal Ul, and native CLI experience for managing and interacting with
      LocalStack deployments.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ purcell ];
    platforms = lib.platforms.unix;
  };
})
