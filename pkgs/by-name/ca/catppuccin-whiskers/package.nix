{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
let
  version = "2.9.0";
in
rustPlatform.buildRustPackage {
  pname = "catppuccin-whiskers";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "whiskers";
    tag = "v${version}";
    hash = "sha256-KU2cHBtz9rdfhulINRaQm+YZ7n8OBULrSHSSxmoitnk=";
  };

  cargoHash = "sha256-40IPDdxKTWYxsCfsECsXDGwfxXiTEIelxIGAFv3xlU4=";

  meta = {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "Templating tool to simplify the creation of Catppuccin ports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Name
      isabelroses
    ];
    mainProgram = "whiskers";
  };
}
