{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-67foqp8i5JqvtKeq8gibFhd59V8Nf8wkaINe2gd5Huk=";
  };

  cargoHash = "sha256-ckcjd8ZiJxfKEkpfGvTSKv3ReWn3lIK+/fBnj/kk2F0=";

  meta = with lib; {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
