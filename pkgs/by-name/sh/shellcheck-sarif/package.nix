{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-G69DiDl78vkPuLodsRTL7dbbIFtNNF/XWuLZpCHKJws=";
  };

  cargoHash = "sha256-ZA7l7fmQG1wjT8oLVp6w2okPlwfNGQw/7qrH3rRS+0o=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool to convert shellcheck diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "shellcheck-sarif";
  };
}
