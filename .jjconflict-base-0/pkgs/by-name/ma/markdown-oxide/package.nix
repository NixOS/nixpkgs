{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markdown-oxide";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hgXqJwmIpXJNIl67Jjbg5MR4PlwB5XbqnFo+rNLoqbE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-o4wn6L5PVZM0SN8kA34NOp6ogTSoCv2xiN4vfj+ptc8=";

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
