{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.11.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-TGraX1H9grqTm3kQ3NLET2EnD9pzdiblEfMt+g5Szkc=";
  };

  cargoSha256 = "sha256-OAQaazT4ChmTokw5yFKaGxwAXJklNgPWaegJVsCkOaA=";

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
