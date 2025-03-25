{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.12.0-dev.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-p+wt5PQPirzBION1qWmce7tXF3X9ngrPQefIXUCFwrI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-sX77xxrJZqm4Qa0ffF7Ozv9LpTvoMiWLgrVzy5Rs2JA=";

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

  meta = with lib; {
    description = "Turing-complete language for creating provable programs for general computation";
    homepage = "https://github.com/starkware-libs/cairo";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
