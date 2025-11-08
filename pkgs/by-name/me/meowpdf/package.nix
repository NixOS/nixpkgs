{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meowpdf";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "monoamine11231";
    repo = "meowpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2/hg0zXgnJwvQv5WcRc36x1StXVLkl81EmujGj87PKM=";
  };

  cargoHash = "sha256-OH+0Pxb4QcRkjT2cOi9GJa5jss1DaMKUzVSmiwyIoAg=";

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
