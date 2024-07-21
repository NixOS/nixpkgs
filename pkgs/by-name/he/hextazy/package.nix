{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "faelian";
    repo = "hextazy";
    rev = "${version}";
    hash = "sha256-e1uoKMejdTz8KH7uFkZ9YCE1WTwaxCZjcxh4g2ermNY=";
  };

  cargoHash = "sha256-5Z+ptr1JmeiP4hK8k+M1d189I0X53/jRUEFwgWGK3xQ=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/faelian/hextazy";
    changelog = "https://github.com/faelian/hextazy/releases/tags/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
