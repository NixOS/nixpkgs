{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-4ZSRwQuZUtk2kY62lruj+uwP6H1sK9J7V6HFQL+t9tw=";
  };

  cargoHash = "sha256-xPi/C9N3/9AsinmbHI/M9EGy4gvS7ZWXEl3xBf3f4LQ=";

  meta = with lib; {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
