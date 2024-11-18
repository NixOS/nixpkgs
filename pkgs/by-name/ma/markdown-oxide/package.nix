{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "markdown-oxide";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "Feel-ix-343";
    repo = "markdown-oxide";
    rev = "v${version}";
    hash = "sha256-LMDL2jLHKgPBkz7QcU4yVzR2ySaboCZ9AOKmdA/NA4c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-o4wn6L5PVZM0SN8kA34NOp6ogTSoCv2xiN4vfj+ptc8=";

  meta = with lib; {
    description = "Markdown LSP server inspired by Obsidian";
    homepage = "https://github.com/Feel-ix-343/markdown-oxide";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [
      linsui
      jukremer
    ];
    mainProgram = "markdown-oxide";
  };
}
