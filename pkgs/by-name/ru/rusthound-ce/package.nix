{
  fetchCrate,
  lib,
  libkrb5,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusthound-ce";
  version = "2.4.7";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-GxkrTXlCVPEZvsu6wck1BbXinFSdnTmnWHy9LH1ymdQ=";
  };

  cargoHash = "sha256-mvsGi5M4Ut0BnX2204AX2nBIdZ8Gtap8wf9pWc6RlpU=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libkrb5
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Active Directory data ingestor for BloodHound Community Edition written in Rust";
    homepage = "https://github.com/g0h4n/RustHound-CE";
    changelog = "https://github.com/g0h4n/RustHound-CE/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eleonora ];
    mainProgram = "rusthound-ce";
  };
})
