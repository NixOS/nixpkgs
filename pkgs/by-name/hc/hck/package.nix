{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hck";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "hck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W5y9NQjRkbb+ifOFMbqDECsm58rk6pozDprMnzC0euk=";
  };

  cargoHash = "sha256-coaRVmI++074P8PhZ/Zmok0lwtEz+/38nkF2h0JraAo=";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      unlicense
    ];
    maintainers = with lib.maintainers; [
      gepbird
    ];
    mainProgram = "hck";
  };
})
