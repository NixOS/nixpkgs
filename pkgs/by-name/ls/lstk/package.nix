{
  fetchFromGitHub,
  buildGoModule,
  lib,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "lstk";
  version = "1.4.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "lstk";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-cA8/bvRggRG6BtcOAcHwzVUgRZk4y6XBxqSiX6wiFYQ=";
  };

  vendorHash = "sha256-aUtwLlrYgJfad/syL30eLNCxuT3fE6Q9BW2bkhkzMtU=";

  excludedPackages = "test/integration";

  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-X github.com/localstack/lstk/internal/version.version=${finalAttrs.version}"
  ];

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
