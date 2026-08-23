{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "desync";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ViwNE+8fmYbAMPFd8yiWXDLbaenkgri9PBe92M0Se5U=";
  };

  vendorHash = "sha256-dAFci7GXe1fPPABIG1dngEyGqC5TKa90fyQPYSbJJrk=";

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
        "TestLocalFSDirSetgidWhilePopulated" # cannot setgid in /tmp
        "TestMountIndex" # FUSE does not work in sandbox
        "TestSeed/extract_repetitive_file" # block cloning fails on ZFS
        "TestTar" # xattr.list: operation not supported
        "TestUnTarDirMTime" # xattr.list: operation not supported
        "TestUnTarIntoReadOnlyDir" # xattr.list: operation not supported
        "TestUnTarNoSamePermissionsOverReadOnlyTree" # xattr.list: operation not supported
        "TestUnTarReadOnlyDir" # xattr.list: operation not supported
        "TestUnTarReadOnlyDirNoSamePermissions" # xattr.list: operation not supported
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
