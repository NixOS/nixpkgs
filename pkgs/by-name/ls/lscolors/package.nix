{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.20.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-EUUPVSpHc9tN1Hi7917hJ2psTZq5nnGw6PBeApvlVtw=";
  };

  cargoHash = "sha256-1wAHd0WrJfjxDyGRAJjXGFY9ZBFlBOQFr2+cxoTufW0=";

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
