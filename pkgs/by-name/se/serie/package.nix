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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J84xop9QGRa9pgHGF8ioLwmnXu1t5iO9ZLV2MoYRdEI=";
  };

  cargoHash = "sha256-B9Fn4okfS/OwhR34YwyjhPvpK6DLFuVY0BRubj4Y4MA=";

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
