{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    tag = version;
    hash = "sha256-z7grcv7kfMvPqt9GI/NovGCWD1CZ38oiZ1bYDzZCbFg=";
  };

  cargoHash = "sha256-9JDqeLuQOs2AbrhQfn8pmnURXFyLf9/G9rEuvhedwr4=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
