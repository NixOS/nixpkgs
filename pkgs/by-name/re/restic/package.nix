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
  version = "0.20.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gw6lxLeuD33KGpUurYERK4AgntBHe38lmG6coQlFIR0=";
  };

  vendorHash = "sha256-0X3DE/thqkDe0dKLboz9YrN5xTMwroovEbmjq2PNyek=";

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  nativeCheckInputs = [ python3 ];

  checkFlags = [
    # test fails in sandboxed builds
    "-skip=TestRestoreWithPermissionFailure"
  ];

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
