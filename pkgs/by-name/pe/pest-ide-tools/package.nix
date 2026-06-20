{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pest-ide-tools";
  version = "0.13.2";

  cargoHash = "sha256-KNYQYvklDqn0J82LAbK/zwhvyMhZJ9PMWo0rErDsIMs=";

  src = fetchFromGitHub {
    owner = "pest-parser";
    repo = "pest-ide-tools";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xksPMErUWAoNvteFV387zgh/yzpmw0SUpn3mPIcIV4s=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "IDE support for Pest, via the LSP";
    homepage = "https://pest.rs";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ nickhu ];
    mainProgram = "pest-language-server";
  };
})
