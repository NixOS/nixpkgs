{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iroh-ssh";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "rustonbsd";
    repo = "iroh-ssh";
    tag = finalAttrs.version;
    hash = "sha256-jKJ0dathwsFif2N/X4CnMAG74h0h/5hnuWWwbJrbU18=";
  };

  cargoHash = "sha256-KZu4HA5E9R4sdBW5cdhyA5E2bo2YN2TPSKDlJuzDGnU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/iroh-ssh";
  versionCheckProgramArg = "version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "SSH to any machine without IP";
    homepage = "https://github.com/rustonbsd/iroh-ssh";
    maintainers = with lib.maintainers; [ luke ];
    license = lib.licenses.mit;
    mainProgram = "iroh-ssh";
  };
})
