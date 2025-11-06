{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rucola";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Linus-Mussmaecher";
    repo = "rucola";
    rev = "v${version}";
    hash = "sha256-vBY6tkzLgZuSU5AqH3uzDwjPl/ayWY0S8uRvlgE/Wmw=";
  };

  cargoHash = "sha256-a1f+WSXMNaZCKc7bScknW9WW+Qi1CZIuNLdJseem11I=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  # Fails on Darwin
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=io::file_tracker::tests::test_watcher_rename"
  ];

  meta = {
    description = "Terminal-based markdown note manager";
    homepage = "https://github.com/Linus-Mussmaecher/rucola";
    changelog = "https://github.com/Linus-Mussmaecher/rucola/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "rucola";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
