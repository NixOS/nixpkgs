{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.18.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-m9S8fG0c+67/msdWaN8noazEdsdLk1aswUJ+8hkjhxo=";
  };

  cargoHash = "sha256-6d/v89Yqn9FioWQTb5513kPbO9lnzBxaubfcdCzwUP4=";

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
