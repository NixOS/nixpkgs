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
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "rustonbsd";
    repo = "iroh-ssh";
    tag = finalAttrs.version;
    hash = "sha256-A/QdpPHI9TCqQ2oghxPUJl4KKX8gqkA3kBvN8f1Kegg=";
  };

  cargoHash = "sha256-/cq/rOzrQ4t0qvdaqM3JhRn8IMncx7jWYDjdYmLCYvc=";

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
