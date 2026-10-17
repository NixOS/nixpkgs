{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cairo";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h5oQbpumzl1oJb5GAaiQhp2Yk4efF+oYTNdeZxrE02Y=";
  };

  cargoHash = "sha256-SMfqU2DH20CHu/lsYex0F7c9DClMYCL2kgWeqxw1LW0=";

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
