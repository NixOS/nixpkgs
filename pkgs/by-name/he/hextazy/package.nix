{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    tag = version;
    hash = "sha256-sglKEdmfS8+PHsgZ/Z7HJs9+lrkD0pFvfUDrKtEdRNQ=";
  };

  cargoHash = "sha256-E0ia/I7e40lDG24qYUCOwWNKSZ9/VmI5/4BsIKmE61I=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
