{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.9.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-8r1MTc6sSgHXuioagj7K4f6Kf4WYnnpie17tvzhz7+M=";
  };

  cargoSha256 = "sha256-GsrQKv34EWepq0ihRmINMkShl8nyGQ1Q2De+1Y53TUo=";

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
