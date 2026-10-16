{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cairo";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k+Q8KuHeC75g3zLPBnfTvntw0cr9PN4r7jRgkEL/UrU=";
  };

  cargoHash = "sha256-xU2fCGvHSwf+vX4KH+xolC3qlyQXjDtazmZSiRlQQok=";

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
    maintainers = [ ];
  };
})
