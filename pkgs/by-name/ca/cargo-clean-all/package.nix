{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-clean-all";
  version = "0.6.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dnlmlr";
    repo = "cargo-clean-all";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RPDxeoUoAXNFh2ZabHigmwlztyRG9l9zez1UulrtNyo=";
  };

  cargoHash = "sha256-s/xOS86ncB3gxGiZIXantF/ID/LhpMEkmtD0r8E1/bA=";

  meta = {
    description = "Fast recursive detection and cleaning of rust projects with interactive TUI and filters";
    longDescription = ''
      Fast recursive detection and cleaning of rust projects with interactive
      TUI and filters. Find rust projects anywhere that meet conditions like
      "last used more than 3 days ago" or "freable size > 1GB" and then clean
      them in record time
    '';
    homepage = "https://github.com/dnlmlr/cargo-clean-all";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "cargo-clean-all";
  };
})
