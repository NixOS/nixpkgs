{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3Packages,
  libiconv,
}:

python3Packages.buildPythonApplication rec {
  pname = "granian";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    rev = "v${version}";
    hash = "sha256-ZIwZrLl7goweYUj3t5e0yaOqeppFHXvK9PL3chNZZRw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pyo3-log-0.11.0" = "sha256-UU8064vM7cf20lwfifyPC205CY4tIgif0slDz/Pjf9Q=";
    };
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = [
    libiconv
  ];

  dependencies = [
    python3Packages.uvloop
    python3Packages.click
  ];

  meta = {
    description = "Rust HTTP server for Python ASGI/WSGI/RSGI applications";
    homepage = "https://github.com/emmett-framework/granian";
    license = lib.licenses.bsd3;
    mainProgram = "granian";
    maintainers = with lib.maintainers; [ lucastso10 ];
    platforms = lib.platforms.unix;
  };
}
