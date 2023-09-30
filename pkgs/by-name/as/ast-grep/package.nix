{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    rev = version;
    hash = "sha256-N9hfHgzqwV/G3/xNY2Vx1i2dW6BcABJ/4lkhnLuvIns=";
  };

  cargoHash = "sha256-3ntsPC6OWtSN3MH+3wN2BgOqH69jiW93/xfLY+niARI=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  checkFlags = [
    # disable flaky test
    "--skip=test::test_load_parser_mac"


    # BUG: Broke by 0.12.1 update (https://github.com/NixOS/nixpkgs/pull/257385)
    # Please check if this is fixed in future updates of the package
    "--skip=verify::test_case::tests::test_unmatching_id"
  ];

  meta = with lib; {
    mainProgram = "sg";
    description = "A fast and polyglot tool for code searching, linting, rewriting at large scale";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ montchr lord-valen cafkafk ];
  };
}
