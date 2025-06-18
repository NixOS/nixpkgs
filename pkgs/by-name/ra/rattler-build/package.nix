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
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "rattler-build";
    tag = "v${finalAttrs.version}";
    hash = "sha256-thpo6tD2qWs3FruqujoLd0WLuSDidI3/wdIDOlyEioU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eXsZ0tO1yR5A67GiQQHYv+i4tip7QDLa1oERkVJVQwk=";

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
