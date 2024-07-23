{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "faelian";
    repo = "hextazy";
    rev = "${version}";
    hash = "sha256-ioj1OFNLoIsSMc6eKXREhclmYgs/Lf10viGSVdPLGA0=";
  };

  cargoHash = "sha256-nWB6X3vNGlMGXbtrgCU5o/hXAlzQO4SBrf2qVoxj26M=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/faelian/hextazy";
    changelog = "https://github.com/faelian/hextazy/releases/tags/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
