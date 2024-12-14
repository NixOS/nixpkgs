{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3Packages,
  libiconv,
}:

python3Packages.buildPythonApplication rec {
  pname = "granian";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    rev = "v${version}";
    hash = "sha256-BuGavjNgA2xsp1f1KGQ9JYmAYVL779EC5jDzuRXAjYg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-x/qyNnIUqEgh8fyzn7g4dw7KQxn71l+vlar04PaVI7c=";
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
