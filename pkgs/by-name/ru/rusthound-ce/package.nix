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
  version = "2.5.9";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-VJFgUKsmOD0pt2GABeSufWBaE+3zr0q5bv2h7f6opNg=";
  };

  cargoHash = "sha256-dHJawFfPnU80aocE1oHqdOzX48WgiIz+qknTq9Mt3Ks=";

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
