{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meowpdf";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "monoamine11231";
    repo = "meowpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C5GqyZW0pDmBuaKM890hx2JZtkZqZx+x/RZFCPhpjho=";
  };

  cargoHash = "sha256-hCGMm0ORKuyyWU5D9k+nthSwmq8ALz0qASLDaMiW30U=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "PDF viewer for the Kitty terminal with GUI-like usage and Vim-like keybindings written in Rust";
    homepage = "https://github.com/monoamine11231/meowpdf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "meowpdf";
    platforms = lib.platforms.linux;
  };
})
