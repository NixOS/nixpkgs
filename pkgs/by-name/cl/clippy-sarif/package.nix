{
  lib,
  fetchCrate,
  rustPlatform,
  clippy,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clippy-sarif";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-J2QtM6lrkOXQO3ZARJWIgjkj0pLzmL9id5b2JNkGeiA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ExH4asrM9MIW1/oslU64LnalEAvmTFuOmersrQM0Wjk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI tool to convert clippy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "clippy-sarif";
    inherit (clippy.meta) platforms;
  };
}
