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
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "rustonbsd";
    repo = "iroh-ssh";
    tag = finalAttrs.version;
    hash = "sha256-/g5U8WW/iqf+ccIsZ5tPhkjVFsoVgDj6sfk/aSgGJBw=";
  };

  cargoHash = "sha256-2NAl4ClPN+OI1EBAkuL/KSiByxU34sBmYDjnRXYuiOY=";

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
    maintainers = with lib.maintainers; [
      luke
      rvdp
    ];
    license = lib.licenses.mit;
    mainProgram = "iroh-ssh";
  };
})
