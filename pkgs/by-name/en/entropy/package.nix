{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "entropy";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "EwenQuim";
    repo = "entropy";
    rev = "v${version}";
    hash = "sha256-Wj+WSJ2dt4mE0yoMSYIQVNVklBxaTXwP2XND4+76VCI=";
  };

  vendorHash = "sha256-rELkSYwqfMFX++w6e7/7suzPaB91GhbqFsLaYCeeIm4=";

  meta = {
    description = "Tool to scan your codebase for high entropy lines, which are often secrets";
    homepage = "https://github.com/EwenQuim/entropy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ starsep ];
    mainProgram = "entropy";
  };
}
