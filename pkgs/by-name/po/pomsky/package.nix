{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage rec {
  pname = "pomsky";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "pomsky-lang";
    repo = "pomsky";
    rev = "v${version}";
    hash = "sha256-BoA59P0jzV08hlFO7NPB9E+fdpYB9G50dNggFkexc/c=";
  };

  cargoHash = "sha256-/tJwJ/xF5a2NEP5A/3swq75wCk9qxgbp7ilH1PqcWJY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  # thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: invalid option '--test-threads''
  doCheck = false;

  meta = {
    description = "Portable, modern regular expression language";
    mainProgram = "pomsky";
    homepage = "https://pomsky-lang.org";
    changelog = "https://github.com/pomsky-lang/pomsky/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
