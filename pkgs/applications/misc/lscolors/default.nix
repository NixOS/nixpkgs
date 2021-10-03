{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.8.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-dwtrs9NlhJ+km2/146HMnDirWRB5Ur5LTmWdKAK03v0=";
  };

  cargoSha256 = "sha256-vQnrLt+VSDPr61VMkYFtjSDnEt+NmWBZUd4qLzPzQBU=";

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
