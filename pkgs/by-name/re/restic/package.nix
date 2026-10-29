{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  versionCheckHook,
  nixosTests,
  openssh,
  rclone,
  python3,
}:

buildGoModule (finalAttrs: {
  pname = "restic";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lLinqZUOsZCPPybvVDB1f8o9Hl5qKYi0eHwJAaydsD8=";
  };

  patches = [
    # The TestRestoreWithPermissionFailure test fails in Nix’s build sandbox
    ./0001-Skip-testing-restore-with-permission-failure.patch
  ];

  vendorHash = "sha256-4GVhG1sjFiuKyDUAgmSmFww5bDKIoCjejkkoSqkvU4E=";

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
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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
