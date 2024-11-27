{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3Packages,
  libiconv,
}:

python3Packages.buildPythonApplication rec {
  pname = "granian";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    rev = "v${version}";
    hash = "sha256-Cuojg2Ko+KH/279z7HGYEthrMAqLgmnoHGjZ8HL7unw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-dRBjN0/EmQlGtQ1iGvSPE30KOHVlkWpjpMU2lpIGUdA=";
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
