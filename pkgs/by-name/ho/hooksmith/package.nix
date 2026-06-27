{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hooksmith";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "TomPlanche";
    repo = "hooksmith";
    tag = "v${finalAttrs.version}";
    hash = "sha256-03EXvJctt/Ro27rna7DrCR1IdxIH2kFEQobSbK84p0s=";
  };

  cargoHash = "sha256-h0kzRDC5W6L/oLllTneKlGbmXxA0tQjmLNdNUesbpHw=";

  __structuredAttrs = true;

  meta = {
    description = "Trivial git hook management tool";
    homepage = "https://github.com/TomPlanche/hooksmith";
    changelog = "https://github.com/TomPlanche/hooksmith/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    mainProgram = "hooksmith";
  };
})
