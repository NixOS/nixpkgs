{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markdown-oxide";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LXFZAMxg2Mlatwx7d4ozofr7H9nrqDxai9U/oB4vkqA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VEYwLTWnFMO6qH9qsO4/oiNeIHgoEZAF+YjeVgFOESQ=";

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
