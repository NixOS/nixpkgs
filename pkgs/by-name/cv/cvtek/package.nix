{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2024-06-08";
in
rustPlatform.buildRustPackage {
  pname = "cvtek";
  inherit version;

  src = fetchFromGitHub {
    owner = "varbhat";
    repo = "cvtek";
    rev = "2996a3ae21b7a78331b567dccf84ecbe68e6a469";
    hash = "sha256-39ul4c7o8YiOczHcqZ567dAqBFx1z1IafHUwMuUHg0o=";
  };

  cargoHash = "sha256-LQJP34RW+tBGwQe9Azezc0YHDsyfb2IyvhrC0r0rnds=";

  meta = {
    description = "Craft your Resume/CV using TOML";
    homepage = "https://github.com/varbhat/cvtek";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ uncenter ];
    mainProgram = "cvtek";
  };
}
