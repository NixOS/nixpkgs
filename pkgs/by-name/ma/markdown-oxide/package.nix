{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markdown-oxide";
  version = "0.25.5";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4K69eBHp1RGv0b7BUwGTErDc2M+XOh5ZIly+XvR1Aa4=";
  };

  cargoHash = "sha256-7peel81Yf//MLIoXXCY3lklkykY9XxY/dfIxuNQyQ64=";

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
