{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gmp,
  mpfr,
  libmpc,
}:

rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fFeHL+Q1Y0J3rOgbFA952rjae/OQgHTznDI0Kya1KMQ=";
  };

  cargoHash = "sha256-hgtSDPQRrqhQALqzVW8z9xXqIv+v5/Sbs6McrUCKiaU=";

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

  meta = with lib; {
    homepage = "https://kalker.strct.net";
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${version}";
    description = "Command line calculator";
    longDescription = ''
      A command line calculator that supports math-like syntax with user-defined
      variables, functions, derivation, integration, and complex numbers
    '';
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      lovesegfault
    ];
    mainProgram = "kalker";
  };
}
