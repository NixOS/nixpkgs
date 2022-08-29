{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.12.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-1tLI+M2hpXWsiO/x27ncs8zn8dBDx18AgsSbN/YE2Ic=";
  };

  cargoSha256 = "sha256-4bFzFztaD9jV3GXpZwCowAhvszedM5ion5/h3D26EY8=";

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
