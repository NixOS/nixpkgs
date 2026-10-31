{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  fosrl-newt,
}:

buildGoModule (finalAttrs: {
  pname = "pangolin-cli";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "cli";
    tag = finalAttrs.version;
    hash = "sha256-/B5otbQ7QCDfo/J1ppYXGlhuSl6yL8539jtrWyvF3rg=";
  };

  ldflags = [
    "-X github.com/fosrl/cli/internal/version.Version=${finalAttrs.version}"
    "-X github.com/fosrl/cli/internal/version.NewtVersionOverride=${fosrl-newt.version}"
    "-X github.com/fosrl/cli/internal/config.ManagedBy=nix"
  ];

  vendorHash = "sha256-d4C3V8J6Abqgo2DPtQqed2Es3cfEOLFaMglAyk2R/ws=";

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
