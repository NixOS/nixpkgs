{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-clean-all";
  version = "0.6.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dnlmlr";
    repo = "cargo-clean-all";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CJzjw/g0Ap7TKC2m+bVlH+/iCUOQITmE6HGvrNzWQ3o=";
  };

  cargoHash = "sha256-9Qv2/XacE82AtZCZS5vtSeVdnD6Ugs+Qn/EVevMndQM=";

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
