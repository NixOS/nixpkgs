{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meowpdf";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "monoamine11231";
    repo = "meowpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2mV/B0bu6HX2mBF7ogcTeZrfepDCzBemad3SwT1aHDs=";
  };

  cargoHash = "sha256-dSM2F5HAgCOMJHSGeGpGqwnqcSkaTBD+8LV+/gJuDYQ=";

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
