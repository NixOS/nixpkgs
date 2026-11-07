{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gmp,
  mpfr,
  libmpc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kalker";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = "kalker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AuQtGgzAKA/AcfruZ6XK4d6qNr9/+sTAEgvh83R+zo8=";
  };

  cargoHash = "sha256-xxZYk4anjGRzbYlzm5UPhjCEXwbYp3NM6ilWfNoVnFM=";

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
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${finalAttrs.version}";
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
})
