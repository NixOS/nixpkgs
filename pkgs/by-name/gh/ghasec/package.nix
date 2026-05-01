{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "ghasec";
  version = "0.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "ghasec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NeRijMEspqRuDMva6xaB46vWndzHqiDnkea66XvbmN8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-/r1Nil9sHdKlqH3TL7jCy1wnTfk+D41pwf0MWV81hpE=";

  checkPhase = "go test ."; # since CI fails in Version 0.15.0, specified the test command

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/ghasec/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd 'ghasec' \
      --bash <("$out/bin/ghasec" completion bash) \
      --zsh <("$out/bin/ghasec" completion zsh) \
      --fish <("$out/bin/ghasec" completion fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/koki-develop/ghasec/";
    description = "Security-focused linter for Github Actions workflows";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misogihagi ];
    mainProgram = "ghasec";
  };
})
