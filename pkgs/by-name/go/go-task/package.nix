{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "go-task";
  version = "3.45.5";

  src = fetchFromGitHub {
    owner = "go-task";
    repo = "task";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YIsFADsGDgBR8TYrvhyz1DR1q6wZXDhjSsWi8DeijFA=";
  };

  vendorHash = "sha256-DQqz/GwV8SIsQsyF39Rzw+ojzhVw6Ih2j5utILEomV4=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/task" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/go-task/task/v3/internal/version.version=${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 0;

  postInstall = ''
    ln -s $out/bin/task $out/bin/go-task
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd task \
      --bash <($out/bin/task --completion bash) \
      --fish <($out/bin/task --completion fish) \
      --zsh <($out/bin/task --completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/task";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "Task runner / simpler Make alternative written in Go";
    changelog = "https://github.com/go-task/task/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
})
