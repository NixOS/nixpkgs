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
  version = "3.50.0";

  src = fetchFromGitHub {
    owner = "go-task";
    repo = "task";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kvogQLgOowv0JfwlvCLtHxZrui+3jwvkL4d89DMPia8=";
  };

  vendorHash = "sha256-2jcyjGJIPdhbahkuDkve4OgWv75i6DgwWe7TtXqGpqg=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://taskfile.dev/";
    description = "Task runner / simpler Make alternative written in Go";
    changelog = "https://github.com/go-task/task/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ parasrah ];
  };
})
