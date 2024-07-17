{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0.6.0";
in
rustPlatform.buildRustPackage {
  pname = "kittysay";
  inherit version;

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "kittysay";
    rev = "v${version}";
    sha256 = "sha256-dJpbRPrpilaOFVPjAESk4DyZtH/hJm16p6pMRqrzOk4=";
  };

  cargoHash = "sha256-r1xdMczqVyX7ZPjkyDdgVW3BFOeKOw1Dp6mGHb2XzrM=";

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
