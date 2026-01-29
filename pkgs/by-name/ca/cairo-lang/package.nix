{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-ctYaW1mmnH9Q1mBqACMsmOo9CW0qhtQHgAV88TSwiXw=";
  };

  cargoHash = "sha256-5UMaGZWggASFpYiTYCGpLrQ0v0B2WKpONxQ0XDZddXc=";

  # openssl crate requires perl during build process
  nativeBuildInputs = [
    perl
  ];

  nativeCheckInputs = [
    rustfmt
  ];

  checkFlags = [
    # Requires a mythical rustfmt 2.0 or a nightly compiler
    "--skip=golden_test::sourcegen_ast"

    # Test broken
    "--skip=test_lowering_consistency"
  ];

  postInstall = ''
    # The core library is needed for compilation.
    cp -r corelib $out/
  '';

  meta = {
    description = "Turing-complete language for creating provable programs for general computation";
    homepage = "https://github.com/starkware-libs/cairo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
