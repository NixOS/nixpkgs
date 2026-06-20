{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "beans";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "hmans";
    repo = "beans";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wJXdl4C9jwtEyKVgdXRU9GCBqjkdJ6N58pK5kEL9tnY=";
  };

  vendorHash = "sha256-TprfPZ/clb7PLMAkxF0y78bCef4XarhgHlIhIPn1nQA=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X github.com/hmans/beans/cmd.version=${finalAttrs.version}"
    "-X github.com/hmans/beans/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/hmans/beans/cmd.date=unknown"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd beans \
      --bash <($out/bin/beans completion bash) \
      --fish <($out/bin/beans completion fish) \
      --zsh <($out/bin/beans completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Issue tracker for you, your team, and your coding agents";
    homepage = "https://github.com/hmans/beans";
    changelog = "https://github.com/hmans/beans/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sleroq ];
    mainProgram = "beans";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
