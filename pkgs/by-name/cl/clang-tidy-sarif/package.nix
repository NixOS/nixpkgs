{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clang-tidy-sarif";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DFen1QYQxArNfc0CXNtP0nZEvbCxqTH5KS3q3FcfDPs=";
  };

  cargoHash = "sha256-yMiniPQJz2OKiwhM7OD9111PcjiQ1w3DgSM9hiMCXNs=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI tool to convert clang-tidy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "clang-tidy-sarif";
    license = lib.licenses.mit;
  };
}
