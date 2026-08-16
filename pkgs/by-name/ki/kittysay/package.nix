{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "1.1.1";
in
rustPlatform.buildRustPackage {
  pname = "kittysay";
  inherit version;

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "kittysay";
    rev = "v${version}";
    hash = "sha256-+WrIMte1RXi8nZNvrH/e/2JMx39LkKi8pkq/TUfmzFo=";
  };

  cargoHash = "sha256-7bAPKZAiX/p5xvIbGBBf8O1rksnizIJfMkUwhkpouAA=";

  doCheck = false;

  meta = {
    description = "Cowsay, but with a cute kitty :3";
    homepage = "https://github.com/uncenter/kittysay";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      isabelroses
      uncenter
    ];
    mainProgram = "kittysay";
  };
}
