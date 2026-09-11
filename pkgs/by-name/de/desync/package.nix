{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "desync";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xiiN+0veHRxVNsIpob7W/iRH+dABYIiWfw22DH1bTEs=";
  };

  vendorHash = "sha256-FRXwQUOD1UiGSlGkBLXT0RGG382RJdEGUJxaQiyzR9A=";

  ldflags = [ "-X main.version=${finalAttrs.src.tag}" ];

  nativeBuildInputs = [ installShellFiles ];

  # required for TestHTTPHandlerReadWrite and other tests
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = lib.optionals stdenv.hostPlatform.isDarwin [
        "TestS3StoreGetChunk/fail" # sendfile is not permitted in Darwin sandbox
        "TestS3StoreGetChunk/recover" # sendfile is not permitted in Darwin sandbox
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd desync \
      --bash <($out/bin/desync completion bash) \
      --fish <($out/bin/desync completion fish) \
      --zsh <($out/bin/desync completion zsh)

    mkdir -p $out/share/man/man1
    $out/bin/desync manpage --section 1 $out/share/man/man1
  '';

  meta = {
    description = "Content-addressed binary distribution system";
    mainProgram = "desync";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = "https://github.com/folbricht/desync";
    changelog = "https://github.com/folbricht/desync/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ matshch ];
  };
})
