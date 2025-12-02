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
  version = "2.4.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-WkqelaUTg6GoCoZa/DB5o40Cpfh9iAS0qrSgVwnMrHM=";
  };

  cargoHash = "sha256-LLq9Nzx/0UgGPQSPUVFpRmEpRBZwUJIaAKdM5j+mvCI=";

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
    changelog = "https://github.com/g0h4n/RustHound-CE/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eleonora ];
    mainProgram = "rusthound-ce";
  };
})
