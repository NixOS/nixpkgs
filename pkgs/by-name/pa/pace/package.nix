{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}: let
  version = "0.15.2";
in
  rustPlatform.buildRustPackage {
    pname = "pace";
    inherit version;

    src = fetchFromGitHub {
      owner = "pace-rs";
      repo = "pace";
      rev = "refs/tags/pace-rs-v${version}";
      hash = "sha256-gyyf4GGHIEdiAWvzKbaOApFikoh3RLWBCZUfJ0MjbIE=";
    };

    cargoHash = "sha256-D7jxju2R0S5wAsK7Gd8W32t/KKFaDjLHNZ2X/OEuPtk=";

    nativeBuildInputs = [installShellFiles];

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd pace \
        --bash <($out/bin/pace setup completions bash) \
        --fish <($out/bin/pace setup completions fish) \
        --zsh <($out/bin/pace setup completions zsh)
    '';

    meta = {
      description = "Command-line program for mindful time tracking";
      homepage = "https://github.com/pace-rs/pace";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [isabelroses];
      mainProgram = "pace";
    };
  }
