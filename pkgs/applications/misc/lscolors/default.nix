{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.16.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-gLtQIqdU6syTo+Z+P59kIpwEtiGCr/DOom9+jA8Uq98=";
  };

  cargoHash = "sha256-OA9iYGwKElvRaKoyelH9w5ZphoLKrbk8VXwZ2NyLLQY=";

  buildFeatures = [ "nu-ansi-term" ];

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    changelog = "https://github.com/sharkdp/lscolors/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
