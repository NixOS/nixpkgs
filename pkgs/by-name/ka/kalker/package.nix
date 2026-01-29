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
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = "kalker";
    rev = "v${version}";
    hash = "sha256-P8Yj6uqIZ3twkIJUMZhxrisWQ27LHYIHm3x6cjNR0Ns=";
  };

  cargoHash = "sha256-nYxpSnyXWnrj/HWH7x6yw5CSBqTvLUWdlBv1E6U/Ihg=";

  cargoPatches = [ ];

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
      lovesegfault
    ];
    mainProgram = "kalker";
  };
}
