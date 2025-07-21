{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "conduktor-ctl";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "conduktor";
    repo = "ctl";
    rev = "refs/tags/v${version}";
    hash = "sha256-czKQQT/9w2r8BDIP8aqeAG7B0Yk+HmpjgolovHxSlTM=";
  };

  vendorHash = "sha256-kPCBzLU6aH6MNlKZcKKFcli99ZmdOtPV5+5gxPs5GH4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X github.com/conduktor/ctl/utils.version=${version}" ];

  checkPhase = ''
    go test ./...
  '';

  postInstall =
    ''
      mv $out/bin/ctl $out/bin/conduktor
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd conduktor \
        --bash <($out/bin/conduktor completion bash) \
        --fish <($out/bin/conduktor completion fish) \
        --zsh <($out/bin/conduktor completion zsh)
    '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${placeholder "out"}/bin/conduktor";

  versionCheckProgramArg = "version";

  meta = {
    description = "CLI tool to interact with the Conduktor Console and Gateway";
    mainProgram = "conduktor";
    homepage = "https://github.com/conduktor/ctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      conduktorbot
      marnas
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
