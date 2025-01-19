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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "conduktor";
    repo = "ctl";
    rev = "refs/tags/v${version}";
    hash = "sha256-gG9ntmvlN/XUayHJHNGM1XdM5g0Q/1ywAuhP8wIoYyQ=";
  };

  vendorHash = "sha256-HoIRw72Rxonwozqqz8z+YtZDKIJ6k5pqjf/EQFkhDik=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X github.com/conduktor/ctl/utils.version=${version}" ];

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

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
