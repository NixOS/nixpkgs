{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "horcrux";
  version = "0.3-unstable-2023-09-19";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "horcrux";
    rev = "5e848abcca49a7ad359f5a24ef4ca7e0eda80889";
    hash = "sha256-YOu3qJadfyA6MKW8OFLr0pFjGMOgCGie2f8VbG79IY0=";
  };

  vendorHash = null;

  meta = {
    description = "Split your file into encrypted fragments so that you don't need to remember a passcode";
    homepage = "https://github.com/jesseduffield/horcrux";
    license = lib.licenses.mit;
    mainProgram = "horcrux";
    maintainers = with lib.maintainers; [ mh ];
  };
}
