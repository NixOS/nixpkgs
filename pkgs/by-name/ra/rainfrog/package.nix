{
  lib,
  darwin,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
let
  version = "0.2.9";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    rev = "refs/tags/v${version}";
    hash = "sha256-PiJRVf+rpYFWRmys7Ca2lLfe5F9/ksIzkpKs6CQWu+A=";
  };

  cargoHash = "sha256-L0gXxV/3+5oRV/Ipm4sRqr9dh9AEChWhtILO3PaNxYY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
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
