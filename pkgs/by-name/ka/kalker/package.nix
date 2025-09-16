{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  gmp,
  mpfr,
  libmpc,
}:

rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = "kalker";
    rev = "v${version}";
    hash = "sha256-fFeHL+Q1Y0J3rOgbFA952rjae/OQgHTznDI0Kya1KMQ=";
  };

  cargoHash = "sha256-LEP2ebthwtpPSRmJt0BW/T/lB6EE+tylyVv+PDt8UoQ=";

  cargoPatches = [
    # Fixes build issue by just running cargo update
    # Can be removed on next release
    (fetchpatch {
      name = "bump_cargo_deps.patch";
      url = "https://github.com/PaddiM8/kalker/commit/81bf66950a9dfeca4ab5fdd12774c93e40021eb1.patch";
      hash = "sha256-XT8jXTMIMOFw8OieoQM7IkUqw3SDi1c9eE1cD15BI9I=";
    })
  ];

  buildInputs = [
    gmp
    mpfr
    libmpc
  ];

  outputs = [
    "out"
    "lib"
  ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  env.CARGO_FEATURE_USE_SYSTEM_LIBS = "1";

  meta = {
    homepage = "https://kalker.strct.net";
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${version}";
    description = "Command line calculator";
    longDescription = ''
      A command line calculator that supports math-like syntax with user-defined
      variables, functions, derivation, integration, and complex numbers
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      lovesegfault
    ];
    mainProgram = "kalker";
  };
}
