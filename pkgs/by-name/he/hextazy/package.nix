{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    rev = "${version}";
    hash = "sha256-5ZT6oXG3dWJ8vPX0oieWQsYJQYCTwtlb1B8kmGlLv0k=";
  };

  cargoHash = "sha256-n1HvkWNbHU8UUlqsCnuKESKQznk1WTe6eQiUJjVVXYE=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tags/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
