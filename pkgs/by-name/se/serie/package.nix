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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LrdpRPpl9vcIKbNsw8mvj/fD7lKAJxnh947wMVQZ7IQ=";
  };

  cargoHash = "sha256-Ye9JXMAc0zBDChCsvkXCC5bVAHq+zxKLzkB198ui0nA=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
})
