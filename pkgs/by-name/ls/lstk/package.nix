{
  fetchFromGitHub,
  buildGoLatestModule,
  lib,
  nix-update-script,
}:
buildGoLatestModule (finalAttrs: {
  pname = "lstk";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "lstk";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-44QWENRM6EtOttun9y/SfY30u27iBqXwWhHWpBV9P+o=";
  };

  vendorHash = "sha256-hnHWODI+ZQPcddQQBIlywoeQhtle7RIJMIQDJkGBjOE=";

  passthru.updateScript = nix-update-script { };

  excludedPackages = "test/integration";

  __darwinAllowLocalNetworking = true;

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
