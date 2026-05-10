{
  lib,
  fetchFromCodeberg,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lspmux";
  version = "0.3.0";

  src = fetchFromCodeberg {
    owner = "p2502";
    repo = "lspmux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WNmejKA1wXbu7+cwxBu1tv0kUunt1LAcGP48fWon/b4=";
  };

  cargoHash = "sha256-Um4BZ1QTHCilOslo/GR7cGvPCX1xNitf6WU8QaehAaE=";

  meta = {
    description = "Share one language server instance between multiple LSP clients to save resources";
    mainProgram = "lspmux";
    homepage = "https://codeberg.org/p2502/lspmux";
    license = with lib.licenses; [ eupl12 ];
    maintainers = with lib.maintainers; [ mrcjkb ];
  };
})
