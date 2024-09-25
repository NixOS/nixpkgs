{
  lib,
  darwin,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
let
  version = "0.2.4";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    rev = "refs/tags/v${version}";
    hash = "sha256-3B56081ZiQPVFAheea2c7h2hQyruWI/q2crb4temVZc=";
  };

  cargoHash = "sha256-rO9tSgtO9q1ad0lzD8aINZhDupR5Q27ZPZPX/S7BM+I=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      AppKit
      CoreGraphics
      SystemConfiguration
    ]
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/achristmascarl/rainfrog/releases/tag/v${version}";
    description = "A database management TUI for postgres";
    homepage = "https://github.com/achristmascarl/rainfrog";
    license = lib.licenses.mit;
    mainProgram = "rainfrog";
    maintainers = with lib.maintainers; [ patka ];
  };
}
