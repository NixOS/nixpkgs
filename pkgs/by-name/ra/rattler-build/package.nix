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
  version = "0.77.0";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "rattler-build";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hMK5WO1wuwGdTVPxl/XuX+xTI/hHC82oK54dFhGZP4I=";
  };

  cargoHash = "sha256-AXwEo27kpKrr/baFjH7dczRngTL9EBWMh2SBnqLQBGk=";

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
