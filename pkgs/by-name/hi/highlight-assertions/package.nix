{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "highlight-assertions";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "thehamsta";
    repo = "highlight-assertions";
    rev = "v${version}";
    sha256 = "sha256-7r8tBJ6JFGUGUsTivzlO23hHiXISajjn2WF12mmbmMg=";
  };

  cargoHash = "sha256-egrxcnDVKKgk1sL5WNMIR2FPwQbjjMy20VWizcTBEtM=";

  # requires nightly features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "Tool for unit testing tree sitter highlights for nvim-treesitter";
    mainProgram = "highlight-assertions";
    homepage = "https://github.com/thehamsta/highlight-assertions";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
