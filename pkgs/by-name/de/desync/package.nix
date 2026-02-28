{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "desync";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aRxWq9gGfglfBixS7xOoj8r29rJRAfGj4ydcSFf/7P0=";
  };

  vendorHash = "sha256-ywID0txn7L6+QkYNvGvO5DTsDQBZLU+pGwNd3q7kLKI=";

  nativeBuildInputs = [ installShellFiles ];

  # required for TestHTTPHandlerReadWrite and other tests
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        "TestExtract" # block cloning fails on ZFS
        "TestExtractCommand/extract_while_regenerating_the_corrupted_seed" # block cloning fails on ZFS
        "TestExtractCommand/extract_with_seed_directory" # block cloning fails on ZFS
        "TestExtractCommand/extract_with_single_seed" # block cloning fails on ZFS
        "TestExtractCommand/extract_with_single_seed,_explicit_data_directory_and_unexpected_seed_options" # block cloning fails on ZFS
        "TestExtractCommand/extract_with_single_seed_and_explicit_data_directory" # block cloning fails on ZFS
        "TestExtractWithNonStaticSeeds" # block cloning fails on ZFS
        "TestMountIndex" # FUSE does not work in sandbox
        "TestSeed/extract_repetitive_file" # block cloning fails on ZFS
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
    changelog = "https://github.com/folbricht/desync/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chaduffy ];
  };
})
