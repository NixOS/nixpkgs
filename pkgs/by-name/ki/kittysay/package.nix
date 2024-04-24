{
  lib,
  rustPlatform,
  fetchFromGitHub,
}: let
  version = "0.5.0";
in
  rustPlatform.buildRustPackage {
    pname = "kittysay";
    inherit version;

    src = fetchFromGitHub {
      owner = "uncenter";
      repo = "kittysay";
      rev = "v${version}";
      sha256 = "sha256-eOcHrEvU3nBKFokwE8CyDOUYoBA1+gBlnl7VRUuoFfE=";
    };

    cargoHash = "sha256-dVgPp5jY3ii8mO/HLTDESQzQyZXzqut8Bjm2KfWD0+U=";

    meta = {
      description = "Cowsay, but with a cute kitty :3";
      homepage = "https://github.com/uncenter/kittysay";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [isabelroses uncenter];
      mainProgram = "kittysay";
    };
  }
