{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "serie";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cnuQ6gAL0YRv0DIjuXstPmFRyfQh7c+MHZkc3lzRcRo=";
  };

  cargoHash = "sha256-SavJ6OsTxWUWFWxyfq3B/maqqTRIRiBmwIeXAH3+ZCw=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
})
