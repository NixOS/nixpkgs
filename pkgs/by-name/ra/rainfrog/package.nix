{
  lib,
  darwin,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
let
  version = "0.2.6";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "rainfrog";

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    rev = "refs/tags/v${version}";
    hash = "sha256-yY4F5Aw+duXknESjl6hoOUV3er84DkTtIBoX3humWxA=";
  };

  cargoHash = "sha256-QMZUReWrOS0P+hxsV5c/eJxnwYX977+4oI7MPfz4dgg=";

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
