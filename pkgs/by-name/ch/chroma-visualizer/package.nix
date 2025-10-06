{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "chroma";
  version = "unstable-2025-10-06";

  src = fetchFromGitHub {
    owner = "yuri-xyz";
    repo = "chroma";
    rev = "104a775eb091225802c408202a1daa88dc902d87";
    hash = "sha256-8yYtZXOczGSmo8GgaoqWkGhKgzXeymPRkX8DBpN/y6c=";
  };

  cargoHash = "sha256-G0Ae2IlrdoJjpTdZ4615tWlSDatGf3LdMCwsTrZEnwg=";
  cargoBuildFlags = [
    "--features"
    "audio"
  ];

  meta = {
    homepage = "https://github.com/yuri-xyz/chroma";
    description = "Shader-based audio visualizer for the terminal";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ schrobingus ];
  };
}
