{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.17.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-efkSiwxL7sZIwFXJZunddAb4lTOfhj8oOEOUW3kyRXI=";
  };

  cargoHash = "sha256-1Cyg4WT4xYqc3s5AOXR9GfcS3qKOgscYujGXR9fzuCA=";

  buildFeatures = [ "nu-ansi-term" ];

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    changelog = "https://github.com/sharkdp/lscolors/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "lscolors";
  };
}
