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
  version = "2.4.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-KqcBhag1NOkZxcuS+J48kwJpCoZ1PZv2S10XXwuIoWc=";
  };

  cargoHash = "sha256-4+iqFmpTzoL/sn/Fxji3czcX3XthHDv1Az+5IVMN3gI=";

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
