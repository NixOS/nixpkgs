{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "25.2.2";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "v${version}";
    hash = "sha256-VDXI/pR7lmIMrsHx9E+oWp0PPUcl83Hc98z6Sh18Hsc=";
  };

  cargoHash = "sha256-fTGIFD6V7L3erzi2RexR9XJNIV/UTu8vwFnrNpeFE4A=";

  # too many tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Mutation testing tool for Rust";
    mainProgram = "cargo-mutants";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
