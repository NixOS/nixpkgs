{
  fetchFromGitHub,
  buildGoModule,
  lib,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "lstk";
  version = "0.21.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "lstk";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-8OV+VaoVm9hW2kzPggmXHsoYTL9yzFKfVM9DdnAxOCE=";
  };

  vendorHash = "sha256-WiWMOudPoS3qOMs+m/pz9VYZ9OPRn3IWHxAMC6eBjtg=";

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
