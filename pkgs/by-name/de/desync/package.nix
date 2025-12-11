{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "desync";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    tag = "v${version}";
    hash = "sha256-TwzD9WYi4cdDPKKV2XoqkGWJ9CzIwoxeFll8LqNWf/E=";
  };

  vendorHash = "sha256-CBw5FFGQgvdYoOUZ6E1F/mxqzNKOwh2IZbsh0dAsLEE=";

  nativeBuildInputs = [ installShellFiles ];

  # required for TestHTTPHandlerReadWrite and other tests
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        "TestMountIndex" # FUSE does not work in sandbox
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # sendfile is not permitted in Darwin sandbox
        "TestS3StoreGetChunk/fail"
        "TestS3StoreGetChunk/recover"
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
    changelog = "https://github.com/folbricht/desync/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chaduffy ];
  };
}
