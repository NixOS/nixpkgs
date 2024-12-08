{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexyl";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hexyl";
    rev = "refs/tags/v${version}";
    hash = "sha256-v/mB0W/AyoJSoK00pqxpfMGZR/4DkkTCnPU6eorl/GI=";
  };

  cargoHash = "sha256-QaOp7dCXfkIpxAJ+J+Pt9op3uj+LYoYvR78BmHBgnqE=";

  meta = {
    description = "Command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage = "https://github.com/sharkdp/hexyl";
    changelog = "https://github.com/sharkdp/hexyl/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      dywedir
      figsoda
      SuperSandro2000
    ];
    mainProgram = "hexyl";
  };
}
