{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage rec {
  pname = "pomsky";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "pomsky-lang";
    repo = "pomsky";
    rev = "v${version}";
    hash = "sha256-0rLY0WZj8p9D834SqHogV77GLHLesyPPxMGszDmkB9U=";
  };

  cargoHash = "sha256-zUK8v96/jHaprrfbym23X7e/ZRoDwfNyDt+GIcd7BmY=";

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
    maintainers = [ ];
  };
}
