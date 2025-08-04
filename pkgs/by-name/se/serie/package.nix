{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-26B/bwXz60fcZrh6H1RPROiML44S1Pt1J3VrJh2gRrI=";
  };

  cargoHash = "sha256-Bdk553tECJiMxJlXj147Sv2LzH+nM+/Cm5BpBr78I4o=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
}
