{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-addr2line";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "gimli-rs";
    repo = "addr2line";
    tag = version;
    hash = "sha256-1kjFrDHfvGdU5FfSaLE+EFN83XjF0iSpydwsucjV7NQ=";
  };

  cargoBuildFlags = "--bin addr2line --features bin";

  cargoHash = "sha256-IJ+hZ36QL5Awq4vI+ajTTHwbRU4paG+bnB/TZU9bCCk=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform `addr2line` clone written in Rust, using `gimli`";
    homepage = "https://github.com/gimli-rs/addr2line";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.axka ];
    mainProgram = "addr2line";
  };
}
