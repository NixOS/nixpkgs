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

  useFetchCargoVendor = true;
  cargoHash = "sha256-AfkiK91vXaw4oWvfYlV3C0M/cGf4ZThALB/cANcZmFQ=";

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
