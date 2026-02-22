{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cairo";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lSPIkU36y2WYlfE5TDzYwiGU5BAklFfpyj0UIRC+O14=";
  };

  cargoHash = "sha256-LBfhxQVSpK8C5PNYE6GA1AbySy1mqCaz44SpjPyN1h8=";

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
