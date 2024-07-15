{
  lib,
  rustPlatform,
  fetchFromGitHub,
}: let
  version = "0.8.0";
in
  rustPlatform.buildRustPackage {
    pname = "kittysay";
    inherit version;

    src = fetchFromGitHub {
      owner = "uncenter";
      repo = "kittysay";
      rev = "v${version}";
      hash = "sha256-ZYHrDBJ8cTqJAh2KUGSCsS1bY/emHRodPxZX2vxAhDs=";
    };

    cargoHash = "sha256-F0WAtpAjBwL5YfzGtPgn7WTL6lgx3bjZFBQdDpjCr3I=";

    meta = {
      description = "Cowsay, but with a cute kitty :3";
      homepage = "https://github.com/uncenter/kittysay";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [isabelroses uncenter];
      mainProgram = "kittysay";
    };
  }
