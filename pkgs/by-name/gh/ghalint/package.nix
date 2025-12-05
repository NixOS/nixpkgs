{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ghalint";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "ghalint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zll71vSqSKIij/TUi4LnGtVqmLhK9UViFDkpnuEvmz8=";
  };

  vendorHash = "sha256-pCrVBgS7eLCYlfY6FyAGAeEhpV2dYQowtE/BoRUju0o=";

  subPackages = [ "cmd/ghalint" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd 'ghalint' \
      --bash <("$out/bin/ghalint" completion bash) \
      --zsh <("$out/bin/ghalint" completion zsh) \
      --fish <("$out/bin/ghalint" completion fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/suzuki-shunsuke/ghalint";
    description = "GitHub Actions linter for security best practice";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "ghalint";
  };
})
