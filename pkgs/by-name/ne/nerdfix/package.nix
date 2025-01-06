{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-Mp8QFzMQXJEFIzkrmiW/wxMy/+WC4VqbPtWzE92z9Gc=";
  };

  cargoHash = "sha256-g3Y9yGvWoXPcthDX2/nfWVmNW5mJYILgrJc+Oy+M2fk=";

  meta = {
    description = "Nerdfix helps you to find/fix obsolete nerd font icons in your project";
    mainProgram = "nerdfix";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
