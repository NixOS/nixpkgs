{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pangolin-cli";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "cli";
    tag = finalAttrs.version;
    hash = "sha256-6TRO7tBrWH6EeMFEA6FrpvmlCkUcMtiZ5qr/LQjcLeY=";
  };

  ldflags = [
    "-X github.com/fosrl/cli/internal/version.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-UmzzZDO2lz/HsrUlnV8Wa4GM8lYgoI0ggJlOvxrd79Q=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cli $out/bin/pangolin
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pangolin \
      --bash <($out/bin/pangolin completion bash) \
      --fish <($out/bin/pangolin completion fish) \
      --zsh <($out/bin/pangolin completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pangolin CLI tool and VPN client";
    homepage = "https://github.com/fosrl/cli";
    changelog = "https://github.com/fosrl/cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      water-sucks
      jackr
    ];
    mainProgram = "pangolin";
  };
})
