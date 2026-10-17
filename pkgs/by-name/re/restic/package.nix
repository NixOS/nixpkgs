{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  versionCheckHook,
  nixosTests,
  fuse3,
  openssh,
  rclone,
  python3,
}:

buildGoModule (finalAttrs: {
  pname = "restic";
  version = "0.19.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lj2+SZFvZl/WcC4aV7yZMEYVOyDNMFeHJbUWS53usqg=";
  };

  patches = [
    # The TestRestoreWithPermissionFailure test fails in Nix’s build sandbox
    ./0001-Skip-testing-restore-with-permission-failure.patch

    # Remove in next release
    # https://github.com/restic/restic/pull/22000
    ./0002-mount-bump-anacrolix-fuse-for-fusermount3-support.patch
  ];

  vendorHash = "sha256-2YlLMzV2OJEwGxM8XgIRTWEf9Jf1BfNhMhxUq0MLFWU=";

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  nativeCheckInputs = [ python3 ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    restic = nixosTests.restic;
  };

  postPatch = ''
    rm cmd/restic/cmd_mount_integration_test.go
  '';

  postInstall = ''
    wrapProgram $out/bin/restic \
      --prefix PATH : "${
        lib.makeBinPath [
          openssh
          rclone
        ]
      }"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/restic \
      --suffix PATH : "${lib.makeBinPath [ fuse3 ]}"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/restic generate \
      --bash-completion restic.bash \
      --fish-completion restic.fish \
      --zsh-completion restic.zsh \
      --man .
    installShellCompletion restic.{bash,fish,zsh}
    installManPage *.1
  '';

  meta = {
    homepage = "https://restic.net";
    changelog = "https://github.com/restic/restic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Backup program that is fast, efficient and secure";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      mbrgm
      djds
      dotlambda
      ryan4yin
    ];
    mainProgram = "restic";
  };
})
