{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.15.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-C7aM9jlChRwPvYnBjLbV+sfbTHDVVi6evIR5PvT9jN4=";
  };

  cargoHash = "sha256-93FAEhl0WFXRq1SaoLRNDd/fy7NyDbeRFgIqUWAssQE=";

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
