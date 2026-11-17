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
  version = "2.67.0-lock.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aquaproj";
    repo = "aqua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FYADXXmgGajYVPEgC3BRUejGsCxxVU3V+nmdfz0M+Yw=";
  };

  vendorHash = "sha256-9EfrHa5UZoDgUshTjsy3mpkKUHBmSOuZnT5SAsCNWTA=";

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
    changelog = "https://github.com/aquaproj/aqua/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paveg ];
    platforms = lib.platforms.unix;
  };
})
