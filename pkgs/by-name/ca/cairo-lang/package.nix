{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cairo";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nU5asbMrFjCr3f40Kw9XGzzKc7Av4dAYcZCC/IwwCRU=";
  };

  cargoHash = "sha256-COeQCj7/995wLsmwgq9I4cRfk6N19L287H8Y2n7Pgxc=";

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
})
