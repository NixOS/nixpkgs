{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autocorrect";
  version = "2.16.3";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "autocorrect";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SRG603v6yP8/p3aUgGKRdbZScd818A+WqizcyPXaGB4=";
  };

  cargoPatches = [
    # TODO: remove once upstream updates reqwest and webpki-roots
    #  reqwest 0.11.18 -> 0.12.20 (sync with the latest version of `reqwest` in `Cargo.lock`)
    #  webpki-roots 1.0.1 -> 1.0.11
    ./update-reqwest-and-webpki-roots.patch
  ];

  cargoHash = "sha256-HBzR5A0Y5XI81/LbsI20E7kwBPIikHLrrxZv6F42+Cw=";

  cargoBuildFlags = [
    "-p"
    "autocorrect-cli"
  ];
  cargoTestFlags = [
    "-p"
    "autocorrect-cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linter and formatter for help you improve copywriting, to correct spaces, punctuations between CJK (Chinese, Japanese, Korean)";
    mainProgram = "autocorrect";
    homepage = "https://huacnlee.github.io/autocorrect";
    changelog = "https://github.com/huacnlee/autocorrect/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ definfo ];
  };
})
