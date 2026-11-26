{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
  perl,
  pkg-config,
  aws-lc,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cairo";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z7V+qL6tOOYt3gmMm0T/l+PKLtBRUh3am6+zcQvB6ak=";
  };

  cargoHash = "sha256-qU8JFOV9J8cBEpJOvlenq9BsGI/g5fb4QoOIA4H1mmY=";

  # openssl crate requires perl during build process
  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    aws-lc
    openssl
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
    maintainers = [ ];
  };
})
