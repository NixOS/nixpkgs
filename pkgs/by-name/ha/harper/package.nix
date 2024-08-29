{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "elijah-potter";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-Tk2YOY9myAGHrNTpgwyqo+P6gGQ+2cpKAJbsA3ZfhUA=";
  };

  cargoHash = "sha256-9ITfjrtc8LPQ3u3G59xESzqky/PCiea5mJiTIiEAmSA=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/elijah-potter/harper";
    changelog = "https://github.com/elijah-potter/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
