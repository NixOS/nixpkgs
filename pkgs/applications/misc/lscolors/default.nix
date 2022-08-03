{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.11.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-RU5DhrfB4XlrI4fHUw0/88Ib6H6xvDlRwUNPPwgVKE0=";
  };

  cargoSha256 = "sha256-COWvR7B9tXGuPaD311bFzuoqkISDlIOD6GDQdFa6wT4=";

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
