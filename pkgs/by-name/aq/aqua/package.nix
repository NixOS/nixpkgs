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
  version = "2.66.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aquaproj";
    repo = "aqua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IrJb2TIKgcSffQ4IKmivDEeG2+YJkQN6B1j7+EEKaDk=";
  };

  vendorHash = "sha256-xgFQ2iVUbSRupTdCOBe258D5t7kXVP0xEwkuvm+HRgY=";

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
