{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  writableTmpDirAsHomeHook,
  podman,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snouty";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "antithesishq";
    repo = "snouty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LDcGeRiDYUKDrQZ8pXrRhPFLS0tE16wtgJ8AN3gIVd0=";
  };

  cargoHash = "sha256-IYprp5XEc2DSGWmf9IOKAHfnMX8JbmUWgvKK+CoA1i8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/snouty-*/out/snouty.{bash,fish} \
      --zsh $releaseDir/build/snouty-*/out/_snouty
  '';

  useNextest = true;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    podman
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for the Antithesis API";
    homepage = "https://github.com/antithesishq/snouty";
    changelog = "https://github.com/antithesishq/snouty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      carlsverre
      winter
    ];
    mainProgram = "snouty";
  };
})
