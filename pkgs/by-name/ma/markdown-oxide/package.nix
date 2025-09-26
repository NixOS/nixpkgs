{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markdown-oxide";
  version = "0.25.8";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y3xMiWnLHDVeRn1KbmsC/5yJWhukKFB6X9VHnuEkFU8=";
  };

  cargoHash = "sha256-M4LwkF031bv7aIC9aEh5bF6Vk/DJt3DH1Rh3dUNopX4=";

  meta = {
    description = "Markdown LSP server inspired by Obsidian";
    homepage = "https://github.com/Feel-ix-343/markdown-oxide";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      linsui
      jukremer
      HeitorAugustoLN
    ];
    mainProgram = "markdown-oxide";
  };
})
