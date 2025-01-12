{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "apftool-rs";
  version = "0-unstable-2024-01-05";

  src = fetchFromGitHub {
    owner = "suyulin";
    repo = "apftool-rs";
    rev = "92d8a1b88cb79a53f9e4a70fecee481710d3565b";
    hash = "sha256-0+eKxaLKZBRLdydXxUbifFfFncAbthUn7AB8QieWaXM=";
  };

  cargoHash = "sha256-6lYokd0jwpBWCQ+AbN6ptZYXGcy41GHPbnTELUjPbyA=";

  meta = {
    description = "About Tools for Rockchip image unpack tool";
    mainProgram = "apftool-rs";
    homepage = "https://github.com/suyulin/apftool-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ colemickens ];
    platforms = lib.platforms.linux;
  };
}
