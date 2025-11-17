{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,

  openssl,
  pkg-config,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rattler-build";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "rattler-build";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wh61wde8w6xrnCPiFCh9j+DBqe8kD9/AOe3PEiieefU=";
  };

  cargoHash = "sha256-MH6DSGJ0xZw1+60lB4Yn0K/yiRQYE3KaxEpSih4145M=";

  doCheck = false; # test requires network access

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  cargoBuildFlags = [ "--bin rattler-build" ]; # other bin like `generate-cli-docs` shouldn't be distributed.

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd rattler-build \
        --bash <(${emulator} $out/bin/rattler-build completion --shell bash) \
        --fish <(${emulator} $out/bin/rattler-build completion --shell fish) \
        --zsh <(${emulator} $out/bin/rattler-build completion --shell zsh)
    ''
  );

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Universal package builder for Windows, macOS and Linux";
    homepage = "https://rattler.build/";
    changelog = "https://github.com/prefix-dev/rattler-build/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      genga898
      xiaoxiangmoe
    ];
    mainProgram = "rattler-build";
  };
})
