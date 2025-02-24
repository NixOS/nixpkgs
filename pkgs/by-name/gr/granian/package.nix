{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3Packages,
  libiconv,
}:

python3Packages.buildPythonApplication rec {
  pname = "granian";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    rev = "v${version}";
    hash = "sha256-OjyDwfp0d779oFQ7wUdR1eRPP35kcJa3wIdcYGrGGME=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-jAjHvVyFhGGE/OwfusUE/GdrNrEgvh48lmC5tla4lhI=";
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
