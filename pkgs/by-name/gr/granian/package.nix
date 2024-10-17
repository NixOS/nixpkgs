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

  cargoDeps = rustPlatform.mkCargoVendorDeps {
    inherit pname version src;
    hash = "sha256-wvQBTQXq+VK7wdBQI1Zjw6k+DmpoJWUmZQ9Y5NVWg/0=";
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
