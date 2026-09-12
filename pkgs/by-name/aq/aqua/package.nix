{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

let
  mainProgram = "aqua";
in
buildGoModule (finalAttrs: {
  pname = "aqua";
  version = "2.62.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aquaproj";
    repo = "aqua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kwa7u4UvJ4yq0MKQUz/hF+I4GLZhX+Kzx3PMivfdOpI=";
  };

  vendorHash = "sha256-4m0v1zLgtHq2kMg6Y/a0EytY+jE17A2qbbR1gZ4qTBs=";

  subPackages = [ "cmd/aqua" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${mainProgram} \
      --bash <("$out/bin/${mainProgram}" completion bash) \
      --zsh <("$out/bin/${mainProgram}" completion zsh) \
      --fish <("$out/bin/${mainProgram}" completion fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([\\d\\.]+)$" ];
  };

  meta = {
    inherit mainProgram;
    description = "Declarative CLI version manager";
    homepage = "https://github.com/aquaproj/aqua";
    changelog = "https://github.com/aquaproj/aqua/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paveg ];
    platforms = lib.platforms.unix;
  };
})
