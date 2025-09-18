{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.20.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-EUUPVSpHc9tN1Hi7917hJ2psTZq5nnGw6PBeApvlVtw=";
  };

  cargoHash = "sha256-WsbzlL+RbR8Hnrsbgr7gFpBlo3RBKcNYPbOsZWygyrI=";

  buildFeatures = [ "nu-ansi-term" ];

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    changelog = "https://github.com/sharkdp/lscolors/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "lscolors";
  };
}
